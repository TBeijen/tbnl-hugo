---
title: Controlled initialization of domain objects
author: Tibo Beijen
date: 2009-07-09T07:09:44+00:00
url: /blog/2009/07/09/controlled-initialization-of-domain-objects/
postuserpic:
  - /pa_umlsketch_80.jpg
categories:
  - articles
tags:
  - dao
  - design
  - design patterns
  - domain model
  - oop
  - php

---
In a recent project I&#8217;ve been working on, we have used the &#8216;[Domain Model][1]&#8216; to describe and design our application. Doing so we decouple persistency logic from the objects that are being passed around and modified throughout our application: The Domain objects. So what in MVC is often referred to as &#8216;model&#8217; is actually a combination of a persistency layer, a service layer and a Domain layer. The persistency and service layer are also referred to as Data Access Objects: DAO. (As for the why and how of this architecture I recommend the article [Writing robust backends with Zend Framework][2]. For a good description of the DAO concept [look here][3]). 

One of the challenges we were facing was that on one hand we wanted to implement business rules in our Domain objects. In plainish english: On setting or changing properties of the object (like changing a status) we want to validate if that action is allowed. On the other hand we want to be able to initialize an object to whatever state corresponds with the data fetched from the persistency layer. Doing so we found that the business rules got in the way during initialization when fetching it from the persistency layer. So what we were looking for was a way to allow the service layer to construct a Domain object using methods that are hidden from the rest of the code. We found two ways:

  1. Reflection (as of PHP 5.3)
  2. A design pattern where the Domain object initializes itself using the provided Service object.

<!--more-->

### Das Model: DAO, Domain, Service and Persistency layer

First lets look at how such a Domain object might look like. See simplified example below of an &#8216;order&#8217;:

    class Domain_Order
    {
        protected $id;
        protected $orderDate;
        protected $articles;
        protected $customer;
        protected $invoices;
        protected $statusHistory;
    
        public function getArticles() {}
    
        public function setStatus(OrderStatus $status) {}
    
        // other getters and setters
    }
    

The order has properties like it&#8217;s id, a list of articles, the customer that placed the order and the invoice(s) sent. Besides that it has a status history that actually is a stack of subsequent statuses that correspond to the business processes involved. Possible statuses could be:

  * initiated
  * confirmed
  * payment_confirmed
  * articles_deliverable
  * shipped
  * onhold\_system\_error
  * resolved\_system\_error
  * onhold_helpdesk
  * resolved_helpdesk
  * cancelled_helpdesk
  * completed

Domain objects are fetched, stored and updated by using methods on Service objects. Those service objects implement the aforementioned &#8216;persistency layer&#8217; (could be PDO, webservices, memory, files, etc.). Services are retrieved from a DAO instance that is fetched from a DAO registry. I&#8217;ll cover that more thoroughly in a later post so I&#8217;ll keep it brief:

Bootstrap:

    // bootstrap. setup DAO registry  with 
    // DAO instance that provides service objects
    DAO_Factory->setInstance(
    	new DAO_PDO($initialisedPdo)
    );
    

Fetching an order by id:

    // returns concrete DAO, in this case using PDO for persistency
    $order = DAO_Registry->getInstance() 
    	// the DAO instance returns an 'order' service instance
    	->getServiceOrder()
    	// the service instance provides methods for CRUD type operations
    	->getById($reqOrderId);
    

### Implementing logic

Now let&#8217;s illustrate the concept of putting business rules in the Domain object: If a customer contacts the helpdesk with a difficult question, the helpdesk can put the order on hold to prevent shipping. The status &#8216;onhold_helpdesk&#8217; is added to the status history. But (in our imaginary shop) this can&#8217;t be done if the order is already shipped. So the setStatus() method will validate if the status given is actually allowed and only then perform the action.

The setStatus() method in the order class now looks like this:

    class Domain_Order
    {
        // ... properties and other methods
        public function setStatus(OrderStatus $status)
        {
    		// determine if new status is allowed business-wise
    		if ($newStatusAllowed) {
    			array_push($this->statusHistory, $status);
    		} else {
    			throw new Domain_Order_InvalidStatus_Exception();
    		}
        }
        // ... other methods
    }
    

Calling the setStatus() method should handle the possible exception:

    try {
    	$order->setStatus(
    		new OrderStatus('onhold_helpdesk');
    	);
    } catch (Domain_Order_InvalidStatus_Exception $e) {
    	//  properly handle exception
    }
    

### No public access allowed

To continue the example: If an order is already shipped it can&#8217;t be put on hold. But (at least in this imaginary shop) the other way round goes too: If an order is &#8216;on hold&#8217; the status &#8216;shipped&#8217; can&#8217;t be added. The issue has to be resolved first. From a given state this behaviour is good: invalid actions are prevented. The problem is that the public setters like setStatus() are not suitable for bringing a newly created domain object into it&#8217;s &#8216;persisted&#8217; state. A possible solution might be to add methods that bypass the business logic, but as these methods are used by the service object they need to be public. This is not desired as it allows developers to cut corners that shouldn&#8217;t be cut.

So, back to the start of this post: How to set properties bypassing business-logic?

### 1 . ReflectionProperty (PHP 5.3)

As of PHP 5.3 the [ReflectionProperty][4] class of the [reflection API][5] has a method setAccessible() that allows access to protected and protected properties. Accessing the protected id property of the Order class would look like this:

    class Service
    {
        // ...
    
        public function getById($id)
        {
            // based on the id from the persistency layer 
            // data is retreived. In this demo the data is a hash. 
            // Now it needs to be put into the newly created 
            // Order that is returned.
            $order = new Order();
            
            $refId = new  ReflectionProperty('Order');
            $refId->setAccessible(true);
            $refId->setValue($order, $persistedData['id']);
    
            // ... set other properties
    
            return $order;
        }
        
        // ...
    }
    

The major drawback of using this technique is that the Service class needs to be aware of the internals of the Order class. So, updating the Order class involves needing to update the Service class as well. This breaks basic concepts of OOP. (For a more useful example of reflectionProperty see [this object freezer example][6] by Sebastian Bergmann.

### 2. Protected Link Pattern?

Another way to bypass business-logic on creation without exposing that possibility is to create what could be called a &#8216;protected link&#8217; between the Service and the Order object. See code below:

Service:

    class Service_Order
    {
        // ...
    
        public function getById($id)
        {
            return Order::_init($this,$id);
        }
    
        public function _getInitData(Domain_Order $order, $id)
        {
            // will return 'raw' data (hash/object) as
            // retrieved from the persistency layer
            return $data;
        }
        
        // ...
    }
    

Domain:

    class Domain_Order
    {
        // ... 
        private __construct()
        {
            // no, no, go to the Service
        }
    
        public static function _init(Service_Order $service, $id)
        {
            // create brand new instance
            $order = new Domain_Order();
    
            // fetch persisted data
            $initData = $service->_getInitData($order,$id);
    
            // bring order in it's initial state
            $order->id = $initData['id'];
            $order->orderDate = $initData['orderDate'];
            
            // etc...
    
            return $order;
        }
    
    
        // ... 
    }
    

A static _init() method, that _has_ access to the Order&#8217;s protected properties, is provided with a Service instance and the id of the Order to be initialized. The static Order method then in turn _fetches_ the data from the Service. The new Order instance is then put into the persisted state by directly setting attributes otherwise not accessible. The initialized instance is then returned to the Service which in turn returns it to the requesting code.

On a first glance this might look more complicated than needed: Instead of using a \_getInitData() from the Order class we could also have provided the \_init() method with a data object that implements a certain interface. But this leaves open the option to initialize an Order object with manipulated data that is not directly derived from the persistency layer.

What this _does_ achieve is that it is now impossible to manipulate a Domain object bypassing methods that apply business logic. Yet at the same time that business logic doesn&#8217;t get in the way when initializing a Domain object from the Service layer. A benefit compared to the reflection solution is that the Service object doesn&#8217;t need to be aware of the Order&#8217;s internals. The existence of the Domain layer&#8217;s \_init() and the Service layer&#8217;s \_getInitData() methods are enforced by their respective interfaces or the abstract classes they extend. The design of the transported data (in these examples a hash) can of course also be limited to a certain object type.

A drawback is that there is now a public method \_getInitData on the Service layer. In this example the impact thereof is reduced by requiring an instance of Domain\_Order but that&#8217;s just sugar (or vinegar so you like): It&#8217;s just an indication for developers that they are on the wrong track when they are directly calling _getInitData().

As said, in later posts I plan to elaborate more on the Service and Persistency layers that are briefly shown here. If anyone knows of other ways to address the issue of &#8216;controlled initialization&#8217; I&#8217;m of course very interested.

 [1]: http://en.wikipedia.org/wiki/Domain_model
 [2]: http://www.angryobjects.com/2009/03/30/writing-robust-php-backends-with-zend-framework/
 [3]: http://www.sitecrafting.com/blog/php-patterns-part-ii/
 [4]: http://www.php.net/manual/en/language.oop5.reflection.php#language.oop5.reflection.reflectionproperty
 [5]: http://www.php.net/manual/en/language.oop5.reflection.php
 [6]: http://sebastian-bergmann.de/archives/831-Freezing-and-Thawing-PHP-Objects.html