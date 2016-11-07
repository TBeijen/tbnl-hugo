---
title: 'Zend_Form: Building dynamic forms'
author: Tibo Beijen
layout: post
date: 2009-12-21T10:38:33+00:00
url: /blog/2009/12/21/zend_form-building-dynamic-forms/
postuserpic:
  - /zf_80.jpg
categories:
  - miscellaneous

---
In [my previous post about Zend_Form][1] I showed how, using Zend_Form, a form&#8217;s structure can be separated from it&#8217;s presentation and how to use custom Decorators and Validators. The example used showed a form that is tightly coupled to a record in a database: One form edits one record. There are however numerous occasions where no &#8216;one to one&#8217; connection exists and where the fields that need to be shown are not predetermined. Take for example a shopping cart that shows the amounts of each product. In this article I&#8217;ll take a look at how to:

  * dynamically construct a form based on the data being edited
  * use subforms to reuse common parts and group related values
  * create composite &#8216;elements&#8217; by using the default Zend\_Form\_Element in combination with a custom decorator
  * create additional elements with Javascript and have them processed by the form when submitted

Like previous article the case examined assumes a situation where Zend_Form is used in an existing project that doesn&#8217;t use the Zend Framework MVC stack. The Form [can be viewed online][2] and all of the [sample code can be found on GitHub][3].

### Case outline

In this example I construct a form where a user can view and edit a task list for a week&#8217;s working days. Every task can be edited in one single form and new tasks can be added at will. When viewing the page the application fetches the tasks already entered for that week. The assumed codebase is able to generate and consume an array as shown below:

<pre lang="php">// array format used to supply data of multiple tasks to form
$tasks[$timestampDay1]['current'][$taskId1]['desc'] = 'Gotta do this';
$tasks[$timestampDay1]['current'][$taskId1]['completed'] = true;
$tasks[$timestampDay2]['current'][$taskId2]['desc'] = 'Gotta do that';
$tasks[$timestampDay2]['current'][$taskId2]['completed'] = false;
</pre>

The &#8216;current&#8217; part will later help to distinguish between new and allready stored tasks.

### Dynamically building a Zend_Form

Using Zend_Form typically follows these steps:

<pre lang="php">$Form = new My_Form(); // My_Form::init() will define elements
$Form->setDefaults($myData);
if ($Form->isValid($_POST)) {
    $submittedValues = $Form->getValues();
    // process values and redirect to same or other page
}
echo $Form->render();
</pre>

When a form&#8217;s elements need to be defined based on the data being edited, Zend_Form::init() is not suitable as at that point the data is not known yet. Providing data through the constructor to have it available in the init() method &#8216;could&#8217; work but is not a really nice solution as it means changing the parameter scheme of the constructor. Furthermore, it would ignore the method that exists specifically for adding initial data: setDefaults(). As that will be the first point at which the form &#8216;knows&#8217; what data needs to be edited, that will be the point to add elements. Or, as in this case, subforms.

#### My\_Form\_TaskWeek

The setDefaults() method of the week-form is changed as displayed below:

<pre lang="php">class My_Form_TaskWeek extends Zend_Form
{
    // ...
    public function setDefaults($defaults)
    {
        // first add the subforms
        $this->clearSubForms();
        $dates = array_keys($defaults);
        foreach ($dates as $day) {
            $dayForm = new My_SubForm_TaskDay();
            $this->addSubForm($dayForm, (string) $day);
        }
        // set defaults, which will propagate to newly created subforms
        parent::setDefaults($defaults);
    }
    // ...
}
</pre>

For every day in $defaults (in this example the key is a timestamp, but it could be anything) a subform is added. This is done _before_ calling parent::setDefaults(). With the subforms in place the call to the parent method will propagate to the subforms we&#8217;ve just created.

#### My\_Form\_TaskDay

In the form that shows one single day, some actions _are_ performed in the init() method: A subform for both &#8216;current&#8217; and &#8216;new&#8217; elements is added. Also a &#8216;template&#8217; element is added. The subforms have just one decorator: FormElements. The template element will be used as source for new elements that are added by javascript. When setDefaults() is called, elements are added to the current subform.

<pre lang="php">class My_SubForm_TaskDay extends Zend_Form_SubForm
{
    // ...
   public function init() {
        // create subforms having nothing but element decorator
        $this->addSubForm(new Zend_Form_SubForm, 'current');
        $this->addSubForm(new Zend_Form_SubForm, 'new');
        $this->getSubForm('current')->setDecorators(array('FormElements'));
        $this->getSubForm('new')->setDecorators(array('FormElements'));

        // add template element
        $templateElement = $this->createTaskElement('__template__', array(), true);
        $this->getSubForm('new')->addElement($templateElement);
    }

    public function setDefaults($defaults)
    {
        $subform = $this->getSubForm('current');
        foreach ($defaults['current'] as $id => $values) {
            $subform->addElement($this->createTaskElement($id, $values));
        }
        // set defaults, which will propagate to newly created subforms & elements
        parent::setDefaults($defaults);
    }
</pre>

The method that creates an element:

<pre lang="php">protected function createTaskElement($id, $values, $isNew = false)
    {
        $elm = new Zend_Form_Element((string) $id);
        $elm->clearDecorators();
        $elm->addDecorator(new My_Decorator_TaskElement());
        $elm->addDecorator('Errors', array('placement'=>'prepend'));

        // add configured validator
        $validator = new My_Validator_TaskElement();
        $validator->setIsNew($isNew);
        $elm->addValidator($validator);
        
        return $elm;
    }
</pre>

### Creating composite elements by using custom decorator

As the code above shows, creating a task element consists of three steps:

#### Zend\_Form\_Element

A basic Zend\_Form\_Element is created. This is the &#8216;root&#8217; class of which specific element-types (like Zend\_Form\_Element_Text) are descendants. The Form will supply each element with the element&#8217;s value which in this case will be an associative array with the keys &#8216;desc&#8217; and &#8216;completed&#8217;.

#### My\_Decorator\_TaskElement

A custom decorator is added: My\_Decorator\_TaskElement. This decorator replaces what would normally be the ViewRenderer decorator. It is responsible for rendering _both_ the text and checkbox input elements and wraps them in a div. For the template element (based on the element name) the containing div will be given a classname &#8216;template&#8217; which will be of use when creating the javascript behaviour.

<pre lang="php">public function render($content)
    {
        // get element details
        $elm = $this->getElement();
        $value = $elm->getValue();
        $elmName = $elm->getFullyQualifiedName();

        // construct inputs
        $isCompleted = isset($value['completed']) && $value['completed'];
        $descValue = (isset($value['desc'])) ? htmlspecialchars($value['desc']) : '';

        $inputDesc = sprintf(
            '<input type="text" name="%s" value="%s" />',
            $elmName . '[desc]',
            $descValue
        );
        $inputCompleted = sprintf(
            '&lt;input type="checkbox" name="%s" value="1" %s />',
            $elmName . '[completed]',
            ($isCompleted) ? 'checked="checked"' : ''
        );

        // wrap in div, optionally adding attribute class
        $elmHtml = sprintf(
            '

<div class="task %s">
  %s%s
</div>',
            ($elm->getName() == '__template__') ? 'template' : '',
            $inputDesc,
            $inputCompleted
        );

        // this should be the first decorator but add the content for
        // consistency's sake
        return $content . $elmHtml;
    }
</pre>

#### My\_Validator\_TaskElement

A custom validator is added: My\_Validator\_TaskElement ([see code on GitHub][4]). This validator will check if the description is empty but treats new elements differently from existing ones: For existing elements it is not allowed to have an empty description. For new elements this is only allowed if the &#8216;completed&#8217; checkbox isn&#8217;t checked. (This way a user can still submit the form if he&#8217;d accidentally added a new field). 

### Using jQuery to let the user add new elements

The javascript that lets a user add a new element is implemented as a jQuery plugin. The code having the javascript initiate looks as follows:

<pre lang="javascript">$(document).ready(function() {
    $('form .taskDay').dynamicForm();
});
</pre>

As can be seen each of the &#8216;day&#8217; subforms outer elements is selected and applied upon a jQuery plugin. This plugin ([on GitHub][5])performs the following tasks:

  * Within the element it operates on it searches for an element with classname &#8216;add&#8217; and attaches a &#8216;click&#8217; event handler to it.
  * It searches for an element &#8216;template&#8217; and stores a reference to it.
  * Whenever the user clicks the &#8216;add&#8217; button, the template element is cloned
  * Within the template element the &#8216;name&#8217; attribute of any input element is altered: The string &#8216;\_\_template\_\_&#8217; is replaced by a timestamp. This makes sure that multiple new tasks can be added within a day without them interfering with each other.
  * The new element is placed after the last found element with classname &#8216;task&#8217;

By referring to classnames, the javascript&#8217;s dependencies on the exact HTML are kept to a minimum. This way, if needed, the HTML structure of the form elements can be changed without the need to update the javascript.

### Having the form process the new elements

When the task form is submitted, newly added tasks will be in the $_POST array as shown below:

<pre lang="php">// is assoc. array having 'desc' and 'completed' keys
$_POST[$dayTimestamp]['new'][$uniqueJSCreatedValue];
</pre>

The form object needs to be able to validate the input for both the existing and the new tasks, so the $_POST array is passed to the isValid() method. At this point the form doesn&#8217;t yet contain the &#8216;new&#8217; elements. Adding those is done in a similar fashion to how the existing elements are added in setDefaults(), only this time it is done in isValid(). That is the first point where the form is able to determine what the new elements are. Dynamically adding the new elements happens in the &#8216;day&#8217; subform:

<pre lang="php">class My_SubForm_TaskDay extends Zend_Form_SubForm
{
    // ...
    public function isValid($data) {
        $subform = $this->getSubForm('new');
        // make sure new is array (won't be in $data if nothing submitted)
        if (!isset($data['new'])) {
            $data['new'] = array();
        }
        foreach ($data['new'] as $idx => $values) {
            // Don't add element with idx = __template__. SetIgnore works on
            // getValues. Template elements are submitted so this would otherwise
            // override the previously added template element, thereby losing the
            // setIgnore setting...
            if ($idx !== '__template__') {
                $subform->addElement($this->createTaskElement($idx, $data, true));
            }
        }
        // call parent, which will populate newly created elements.
        return parent::isValid($data);
    }
    //...
}
</pre>

Here the aforementioned createTaskElement() method pops up again. Notice the third parameter (true) that will make the validator treat the element as a &#8216;new&#8217; one.

### All done, except for &#8230; 

In theory now everything works. But practice tends to have those little things that go wrong which you hardly ever read about in code examples. When working on this example I noticed that getValues() doesn&#8217;t preserve the per-day timestamp keys in the array returned. Instead, it returns an indexed array like this:

<pre lang="php">$getValues = array(
    // this '0' should have been a timestamp, like: 1261350000
    '0' => array(
        'current' => array(), // etc. etc.
        'new' => array() // etc. etc.
    ),
    // ...
);
</pre>

Bummer. As it appears, Zend_Form &#8216;requires&#8217; elements, subforms and display groups to have valid variable names (See [ZF-4204][6]). One of the reasons is problably that the names also end up in HTML id attributes which are not allowed to start with a number. The name attribute _is_ though (you can run the demo form through the W3C validator). Remarkably, the task elements, having a name consisting of the database id, are processed just fine.

Two possible solutions for this:

  * Avoid numeric names. Downside is that this also involves changing the existing code generating and processing the array. The day-form header decorator which uses the form&#8217;s name to display the date needs to be changed as well.
  * Add an implementation of getValues() in My\_Form\_TaskWeek that checks for numeric keys and changes them back to their original timestamp

I choose the latter (for now) because it allows to leave almost all existing code unaltered and the resulting behaviour is unit testable (supply defaults, test what is rendered, test what is returned, etc.).

### Conclusion

The above shows that:

  * Subforms are very useful to repeat similar blocks within a form and to group related values in the returned value array.
  * Dynamically adding initial and newly submitted elements follows a similar pattern: Add elements based on the passed in array and then call the parent&#8217;s method. This is done in setDefaults() and isValid() respectively.

The question might arise &#8216;is Zend\_Form the best solution for this type of customized form?&#8217;. The default ViewHelper decorator is ignored, no default validator is used. I can&#8217;t tell if Zend\_Form is the _best_ solution but fact is that it provides a lot of functionallity and flexibility: The Form, Errors and HtmlTag decorators are used &#8216;as is&#8217;. Furthermore, the option to reuse parts comes almost naturally because of Zend_Form&#8217;s design.

Regarding the last point I&#8217;ll conclude with following example: What if, some time after having created this form, the idea is born to have some sort of per-day dashboard page where a user can view and edit things like calendar, messages and tasks? (This is the kind of stuff that happens in agile projects). Reusing My\_SubForm\_TaskDay would be very useful. And luckily that is easily accomplished. All that is needed is wrapping the subform in a class that will additionally:

  * Set a view object
  * Add a submit button
  * Add a Form decorator

See the code of [My\_Form\_TaskDay on GitHub][7] or [see it in action online][8].

 [1]: /blog/2009/12/07/using-zend_form-without-zend-framework-mvc/
 [2]: /static/zend_form_dynamic/
 [3]: http://github.com/TBeijen/Zend_Form_Dynamic
 [4]: http://github.com/TBeijen/Zend_Form_Dynamic/blob/master/htdocs/My_Validator_TaskElement.php
 [5]: http://github.com/TBeijen/Zend_Form_Dynamic/blob/master/htdocs/js/jquery.dynamicform.js
 [6]: http://framework.zend.com/issues/browse/ZF-4204
 [7]: http://github.com/TBeijen/Zend_Form_Dynamic/blob/master/htdocs/My_Form_TaskDay.php
 [8]: /static/zend_form_dynamic/day_only.php