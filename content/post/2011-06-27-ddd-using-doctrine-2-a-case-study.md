---
title: 'DDD using Doctrine 2: A case study'
author: Tibo Beijen
date: 2011-06-27T13:06:57+00:00
url: /blog/2011/06/27/ddd-using-doctrine-2-a-case-study/
postuserpic:
  - /pa_doctrine_80.png
categories:
  - articles
tags:
  - DDD
  - design
  - Doctrine 2
  - Domain Driven Design
  - ORM
  - php

---
Nowadays developing web applications usually requires a flexible process due to changing business logic, shifting priorities or new insights. Besides choosing the right methodology this also requires designing the application in such a way that this flexibility can be achieved. 

[Domain Driven Design][1] fits this process as it isolates business logic in the Domain layer and separates it from infrastructure and presentation layers. Questions like where or how to store data or what to build (website, mobile app, API) can be addressed separately. 

[Doctrine 2][2] provides PHP developers with a powerful tool to create a Domain layer that contains business logic that is easy to unit test and therefore easy to expand upon in iterations.

In this article I will show how to implement a specific case using Doctrine 2. Full code accompanying this article can be [found on GitHub][3].
  
<!--more-->

### In this article

  * [Case outline][4]
  * [Description of Entities][5] 
      * [User][6]
      * [TimeSheet][7]
      * [TimeSheetStatusChange][8]
      * [What&#8217;s not included][9]
  * [Implementing requirements using Doctrine 2][10] 
      * [User should have an e-mail address that is unique][11]
      * [A TimeSheet should always belong to a user which, once specified, cannot be changed][12]
      * [A new TimeSheet by default should have a status ‘open’][13]
      * [Status changes should only be allowed in specific order][14]
      * [A new TimeSheetStatusChange should have a dateApplied that is equal or more recent than the most recent TimeSheetStatusChange][15]
      * [TimeSheetStatusChanges must have reference to a TimeSheet but at the same time must be valid.][16]
  * [Where the domain model goes beyond the database model][17]
  * [Concluding][18]

### Case outline {#caseOutline}

The application developed is a time registration tool that allows users to enter per-day time sheets and submit them for approval. A manager will approve or disapprove the time sheet. The business requirement this iteration focuses on is the tracking of time sheet status history and only allowing specific status changes. In subsequent iterations features like registrations, tasks, projects and permissions will be implemented.

### Description of entities {#descriptionOfEntities}

[<img src="/media/wp-content/uploads/2011/06/yuml-ddd-hrm-001.21-500x46.png" alt="" title="User, TimeSheet and TimeSheetStatusChange entities"   class="aligncenter size-medium wp-image-723" srcset="http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2011/06/yuml-ddd-hrm-001.21-500x46.png 500w, http://www.dev.tibobeijen.nl/blog/wp-content/uploads/2011/06/yuml-ddd-hrm-001.21.png 587w" sizes="(max-width: 500px) 100vw, 500px" />][19]

#### User {#entUser}

A User can login, has attributes and &#8211; interesting for this case &#8211; can have timesheets. A user’s email address can be changed at any time but should be unique as it serves as the login name.

#### TimeSheet {#entTimeSheet}

A TimeSheet holds registrations of a single user, the registrant. Those registrations will be reviewed by a manager who will approve or disapprove them on a per-timesheet basis. The timesheet therefore can have the following statuses:

  * Open &#8211; The default status of every new timesheet
  * Submitted &#8211; The timesheet has been submitted for approval
  * Approved &#8211; The manager has approved the timesheet
  * Disapproved &#8211; The manager has disapproved the timesheet
  * Final &#8211; The timesheet’s registrations have been processed and therefore can never be changed. Examples of processing are periodic business reports or salary payment.

Status changes will be stored to allow a history of status changes to be shown. The most recent status change reflects the timesheet’s ‘current’ status.

Status changes are only allowed to be added in a specific order.

#### TimeSheetStatusChange {#entTimeSheetStatusChange}

Each subsequent status of a timesheet is represented by a TimeSheetStatusChange. Properties of a status change are the status and the date the new status has been applied. Once stored, the status and date properties of a status change are not allowed to change to prevent ‘breaking’ the history of status changes a timesheet went through.

#### What is not included {#entNotIncluded}

As mentioned in the case outline, some obvious entities or properties are out of scope, such as the registrations themselves and the date the timesheet applies to. For the business requirements described previously they are not relevant so, in true Agile fashion, they will be implemented in subsequent iterations.

### Implementing requirements using Doctrine 2 {#implementing}

#### User should have an e-mail address that is unique {#req1}

This is achieved by requiring an e-mail address in the constructor and by setting the column definition of the property to be unique.

_[Domain/Entity/User.php][20]_

    class User
    {
        // ...
    
        /**
         * @Column(type="string", length=128, unique=true)
         * @var string
         */
        private $email;
    
        // ...
    

#### A TimeSheet should always belong to a user which, once specified, cannot be changed {#req2}

This is enforced by requiring a User entity to be supplied in the constructor. As there’s no point in changing the registrant of an existing TimeSheet, the registrant can only be specified on creation. Therefore there is no setter for the registrant property.

(See next code example)

#### A new TimeSheet by default should have a status ‘open’ {#req3}

In the TimeSheet constructor, a new TimeSheetStatusChange is created and added to the status changes. 

_[Domain/Entity/TimeSheet.php][21]_

    class TimeSheet
    {
        // ...
    
        /**
         * Constructor requiring a registrant user instance
         * 
         * @param User $registrant
         */
        public function __construct(User $registrant)
        {
        	$this->registrant = $registrant;
        	
        	$this->statusChanges = new ArrayCollection();
        	$this->addStatusChange(new TimeSheetStatusChange('open'));
        }
    
        // no setRegistrant()
    
        // ...
    

<div class="sidenote">
  <p>
    One might think that adding a default status change to a new instance would result in a duplicate first status change when the persisted status changes are loaded while fetching the TimeSheet from the database. This is not the case as Doctrine 2 does not instantiate the constructor of entities. Read more on: <a href="http://www.doctrine-project.org/blog/doctrine-2-give-me-my-constructor-back">Doctrine 2: Give me my constructor back</a>
  </p>
</div>

#### Status changes should only be allowed in specific order {#req4}

This is achieved by validating each TimeSheetStatusChange that is added via the addStatusChange method. Only specific transitions are allowed.

_[Domain/Entity/TimeSheet.php][21]_

    class TimeSheet
    {
        // ...
    
        /**
         * Performs status change validation logic
         * 
         * @param string $statusChange
         * @return boolean
         */
        protected function _validateNextStatus($nextStatus)
        {
        	// make exception for initial adding of open status
        	if ($nextStatus === 'open' && count($this->statusChanges) === 0) {
        		return true;
        	}
        	
        	// validate status changes map
        	$allowedChangeMap = array(
        		'open' => array('submitted'),
        		'submitted' => array('approved', 'disapproved'),
        		'approved' => array('final', 'disapproved'),
        		'disapproved' => array('submitted', 'approved'),
        		'final' => array(),
        	);
    
        	$currentStatus = $this->getStatus();
        	if (in_array($nextStatus, $allowedChangeMap[$currentStatus], true)) {
        		return true;
        	}
        	
        	return false;
        }
    
        // ...
    }
    

#### A new TimeSheetStatusChange should have a dateApplied that is equal or more recent than the most recent TimeSheetStatusChange {#req5}

The dateApplied property is settable because it can’t be assumed that the time at which the change is entered into the application reflects the actual time of the change (An example would be paper forms that are collected and entered once a week). Therefore the dateApplied property is validated at the same time the status is validated. Furthermore, once added, the dateApplied property cannot be changed so there is no setter. When loading a TimeSheet, the TimeSheetStatusChanges are fetched in order by specifying the [orderBy][22] attribute in the association.

_[Domain/Entity/TimeSheet.php][21]_

    class TimeSheet
    {
        // ...
    
        /**
         * @OneToMany(targetEntity="Domain\Entity\TimeSheetStatusChange", mappedBy="timeSheet", cascade={"persist"}, orphanRemoval=true)
         * @OrderBy({"dateApplied" = "ASC", "id" = "ASC"})
         */
        private $statusChanges;
        
        // ...
    
        /**
         * Validates if the date of the statusChange given is later than the date
         * of the last statusChange present
         */
        protected function _validateNextStatusChangeDate(TimeSheetStatusChange $statusChange)
        {
        	// if no statusChanges present yet any date is valid
        	if (count($this->statusChanges) === 0) {
        		return true;
        	}
        	
        	$currentDate = $this->getLastStatusChange()->getDateApplied();
        	$nextDate = $statusChange->getDateApplied();
        	
        	// enable once tests finish
    		return ($nextDate >= $currentDate);
        }
    
        // ...
    }
    

#### TimeSheetStatusChanges must have reference to a TimeSheet but at the same time must be valid. {#req6}

It can be prevented to store a TimeSheetStatusChange without reference to a TimeSheet by explictly specifying the joinColumn and setting the nullable attribute to false.

_[Domain/Entity/TimeSheetStatusChange.php][23]_

    class TimeSheetStatusChange
    {
        // ...
    
        /**
         * @ManyToOne(targetEntity="Domain\Entity\TimeSheet", inversedBy="statusChanges")
         * @JoinColumn(name="timesheet_id", referencedColumnName="id", nullable=false)
         */
        private $timeSheet;
    
        // ...
    }
    

This still leaves the possibility to set ‘any’ TimeSheet and thereby skipping validation that would normally be done in TimeSheet::addStatusChange(). To prevent this, TimeSheetStatusChange::setTimeSheet() verifies if the TimeSheet’s last status is the current TimeSheetStatusChange instance. 

_[Domain/Entity/TimeSheet.php][21]_

    class TimeSheetStatusChange
    {
        // ...
    
        /**
         * Sets the timeSheet.
         * 
         * Purpose is to have the reference to the timeSheet set when adding a 
         * new TimeSheetStatusChange to a TimeSheet. Therefore this method validates
         * if the timeSheet has the this instance as the last statusChange.
         * 
         * @param TimeSheet $timeSheet
         */
        public function setTimeSheet(TimeSheet $timeSheet)
        {
        	if ($timeSheet->getLastStatusChange() !== $this) {
        		throw new \InvalidArgumentException('Cannot set TimeSheet if not having current instance as lastStatusChange');
        	}
        	$this->timeSheet = $timeSheet;
        }
        // ...
    }
    

The result is that the only way to create a persistable TimeSheetStatusChange is by adding it to the TimeSheet which will:

  1. Validate if the status change is allowed
  2. Adds it to the list of status changes, making it the ‘last’ status change
  3. In turn set the timeSheet reference on the TimeSheetStatusChange

Persisting a TimeSheet is propagated to the status changes by setting the cascade attribute in the association definition

_[Domain/Entity/TimeSheet.php][21]_

    class TimeSheetStatusChange
    {
        // ...
    
        /**
         * @OneToMany(targetEntity="Domain\Entity\TimeSheetStatusChange", mappedBy="timeSheet", cascade={"persist"}, orphanRemoval=true)
         * @OrderBy({"dateApplied" = "ASC", "id" = "ASC"})
         */
        private $statusChanges;
    
        // ...
    }
    

### Where the domain model goes beyond the database model {#beyondDatabase}

One might be tempted to see an ORM as merely a convenient way to access and manipulate data contained in a database. While Doctrine 2 fits such a scenario (Entities can be modeled to reflect an already existing database) the real power shines when entities are modeled with business logic in mind instead of just being a collection of setters and getters matching the database fields.

Features displayed in these examples that can not be expressed in a database model include:

  * Forcing each timesheet to start with a status ‘open’
  * Only allowing specific timesheet status changes: 
      * By preventing ‘floating’ timesheetsStatusChanges to be created.
      * By preventing change of dateApplied and status properties, once created
  * Make values, once persisted immutable. (the registrant property of a timesheet, the status and dateApplied properties of a timesheetStatusChange)

### Concluding {#concluding}

As the previous example shows, a Domain model is more than a database model: It should be modeled to comply with business logic required. As a result, for the code in this article I have used [Doctrine tools][24] only for creating entity proxies, [not the entities themselves][25]

Furthermore, the fact that business logic is only contained in the Domain layer is illustrated by the facts that in this setup:

  * There is no front-end
  * There is no framework (Zend Framework, Symfony, Cake, Yii, Solar, all possibilities are open)
  * There is no specific database. For the tests an in-memory SQLite database is used. In production this will obviously not be the case.

Because of this isolation from other layers, domain logic is easily testable as can be seen from [the test cases][26].

Credits for the test setup used here go to the example found on Giorgio Sironi&#8217;s [ddd-talk GitHub page][27].

In future articles I intend to expand on this case, showing how Domain Driven Design can be used in an Agile development process.

 [1]: http://domaindrivendesign.org/
 [2]: http://www.doctrine-project.org/projects/orm/2.0/docs/en
 [3]: https://github.com/TBeijen/DDD-HRM/tree/v001
 [4]: #caseOutline
 [5]: #descriptionOfEntities
 [6]: #entUser
 [7]: #entTimeSheet
 [8]: #entTimeSheetStatusChange
 [9]: #entNotIncluded
 [10]: #implementing
 [11]: #req1
 [12]: #req2
 [13]: #req3
 [14]: #req4
 [15]: #req5
 [16]: #req6
 [17]: #beyondDatabase
 [18]: #concluding
 [19]: http://www.tibobeijen.nl/blog/wp-content/uploads/2011/06/yuml-ddd-hrm-001.21.png
 [20]: https://github.com/TBeijen/DDD-HRM/blob/v001/Domain/Entity/User.php
 [21]: https://github.com/TBeijen/DDD-HRM/blob/v001/Domain/Entity/TimeSheet.php
 [22]: http://www.doctrine-project.org/docs/orm/2.0/en/reference/annotations-reference.html#orderby
 [23]: https://github.com/TBeijen/DDD-HRM/blob/v001/Domain/Entity/TimeSheetStatusChange.php
 [24]: http://www.doctrine-project.org/docs/orm/2.0/en/reference/tools.html
 [25]: http://www.doctrine-project.org/docs/orm/2.0/en/reference/tools.html#entity-generation
 [26]: https://github.com/TBeijen/DDD-HRM/tree/v001/Test/Domain/Entity
 [27]: https://github.com/giorgiosironi/ddd-talk