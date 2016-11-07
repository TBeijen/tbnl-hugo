---
title: Using Zend_Form without Zend Framework MVC
author: Tibo Beijen
layout: post
date: 2009-12-07T10:13:13+00:00
url: /blog/2009/12/07/using-zend_form-without-zend-framework-mvc/
postuserpic:
  - /zf_80.jpg
categories:
  - articles
tags:
  - php
  - zend framework
  - zend_form

---
Most components of [Zend Framework][1] can be used without using the entire framework and [Zend_Form][2] is no exception. It&#8217;s a versatile component that can be customized to great extent. The payoff is that seemingly easy tasks can seem quite complex to complete and involve concepts like Decorators and View Helpers. Complexity is increased by the fact that most tasks can be achieved in multiple ways.

Forms in general are elements where a lot of parts of an application &#8216;meet&#8217;: Frontend code (HTML/CSS), behavior (JS) and backend processing (validation, filtering and storage). In this post I&#8217;ll show how one can:

  * Use Zend_Form outside the Zend Framework MVC (most likely an existing project)
  * Separate Form rendering from it&#8217;s structure
  * Use custom validators and decorators

The Form used in this tutorial can be [viewed here][3]. The code can be browsed or downloaded [on GitHub][4].

### Zend_Form components at a glance

Let&#8217;s start with a quick look at how Zend_Form&#8217;s different components are tied together:

  * A Zend\_Form consists of elements, descendants of Zend\_Form_Element
  * Elements can be supplied with Validators and Filters
  * Both the form and it&#8217;s elements depend on Decorators to generate HTML. Decorators form a &#8216;chain&#8217; where each decorator adds HTML to the result of the previous decorators.
  * The standard decorators provided by Zend_Form delegate the rendering of the actual HTML to [View Helpers][5]

### Using Zend_Form without the MVC

As the last point above shows, Zend\_Form, through Decorators, makes extensive use of Zend\_View helpers. In a Zend\_Framework project Zend\_Form is able to retrieve the View itself. In other projects (if one wants to use any of Zend\_Form&#8217;s default decorators) a View instance has to be supplied to Zend\_Form:

<pre lang="php">$view = new Zend_View();
$view->doctype('XHTML1_TRANSITIONAL');

$form = new Zend_Form();
$form->setView(new Zend_View());
</pre>

In this example the doctype is specified in the view. This controls if input elements are rendered with XHTML self-closing tags.

### Separate structure and rendering

In this tutorial I create a form for an admin interface where basic user-details can be edited. Let&#8217;s assume an ACL implementation dictates that some people can actually _edit_ the details while others are only allowed to _view_ them. I&#8217;ve decided to keep the form definition (the &#8216;model&#8217; side of a form) to a bare minimum and let different renderers (the &#8216;view&#8217; side) control the output. 

For re-usability and keeping controller code clean one can best create form objects by creating an instance of a subclass of Zend_Form:

<pre lang="php">class My_Form_User extends Zend_Form
{
    public function init() {
        // username
        $this->addElement('text','username', array(
            'required' => true,
            'validators' => array(
                // arguments: type, breakchain, validator constructor options
                array('Alnum', false, false),
                array('StringLength', false, array(6, 16)),
            ),
        ));

        // email
        $EmailValidate = new My_Validator_Email();
        $this->addElement('text','email', array(
            'required' => true,
            'validators' => array(
                array('EmailAddress', false),
                array($EmailValidate, false)
            )
        ));

        // ...
    }
}
</pre>

(As can be seen I create an instance of My\_Validate\_Email and add that to the email element. We&#8217;ll look into that later. First, let&#8217;s continue with the form definition.)

The init() method is designed for this type of form definition, thereby avoiding the need to duplicate the constructor and it&#8217;s parameter scheme. As can be seen, I only define the form elements and validators. Labels and such I defer to the renderer (more on that later). As this is about integrating Zend_Form into existing projects that are not based on Zend Framework, I assume there is some sort of language-aware component. In this example I use a language pack that returns language-specific results based on tags. Adding a set of checkboxes then looks like this:

<pre lang="php">class My_Form_User extends Zend_Form
{
    public function init() {

        // ...

        $lang = new My_LanguagePack();

        $groupIds = array(1,2,3,4);
        $groupOptions = array();
        foreach ($groupIds as $id) {
            $groupOptions[$id] = $lang->get('group.label.' . $id);
        }

        $elmGroup = new Zend_Form_Element_MultiCheckbox('group');
        $elmGroup->setMultiOptions( $groupOptions );
        $elmGroup->setRequired(true);
        $this->addElement($elmGroup);
    }
}
</pre>

Now I create two renderer classes for both the &#8216;edit&#8217; and &#8216;view&#8217; display mode. Both accepting a Zend_Form instance in the constructor. Code below shows how the form is displayed using either rendering class:

<pre lang="php">$Form = new My_Form_User();

$RendererEdit = new My_Form_Renderer_Edit($Form, 'user_edit');
echo $RendererEdit->render();
 
$RendererView = new My_Form_Renderer_View($Form, 'user_view');
echo $RendererView->render();
</pre>

But before moving onto the renderers, let&#8217;s look into the aforementioned My\_Email\_Validator class.

### Adding a custom validator

When specifying validators by string, as is done with &#8216;EmailAddress&#8217;, Zend_Form adds one of the types of [Zend_Validate][6]. For validation not covered by the standard validators one can create a custom validator by extending Zend\_Validate\_Abstract or implementing Zend\_Validator\_Interface. For email addresses, a typical scenario would be a custom validator that connects to a database and checks if the given email address is allready used by another user. For this demo I skip the database part, resulting in:

<pre lang="php">class My_Validator_Email extends Zend_Validate_Abstract
{
    protected $isValid = null;

    public function isValid($value) {
        $this->isValid = !in_array($value, array(
            'duplicate@test.com',
        ));
        return $this->isValid;
    }

    public function getMessages() {
        if ($this->isValid === false) {
            return array(
                'duplicateEmail' => 'This email address is allready used'
            );
        }
        return array();
    }

    public function getErrors() {
        return array_keys($this->getMessages());
    }
}
</pre>

Now let&#8217;s continue with the two renderer classes:

### Rendering the edit mode

The basics of the My\_Form\_Renderer_Edit class constructor are shown below: 

<pre lang="php">class My_Form_Renderer_Edit
{
    protected $form;

    protected $lang;

    public function __construct(Zend_Form $form, $form_id = null)
    {
        $view = new Zend_View();
        $view->doctype('XHTML1_TRANSITIONAL');

        $this->form = $form;
        $this->form->setView(new Zend_View());
        $this->form->setAttrib('class', 'form_edit');
        if (!is_null($form_id)) {
            $this->form->setAttrib('id', $form_id);
        }

        $this->lang = new My_LanguagePack();
    }

    public function render()
    {
        // ...
}
</pre>

As can be seen this is where I setup the view (as mentioned before) and set id and classname that can be used in CSS. I want the HTML to look like this:

<pre lang="xml"><ul>
  <li class="">
    <div id="username-label">
      <label for="username" class="required">* Username</label>
    </div>
            
    
    <div class="element">
      <input type="text" name="username" id="username" value="" class="text" />
                  <span class="description">(Min 6, max 16 char.)</span>
              
    </div>
        
  </li>
  
</ul>
</pre>

When the render() method is called on the renderer class I do four things:

  * Add a submit element
  * Setup element properties that are common for all elements
  * Setup properties on a per-element basis
  * Setup properties of the form element

I&#8217;ll briefly run through those steps. [Complete code for My\_Form\_Renderer_Edit][7] can be seen on Github.

#### Add a submit element

As long as the submit value doesn&#8217;t play a role in the processing of entered data I consider this part of the view layer. For example, interaction design might dictate that on long forms submit buttons are placed both above and below the form.

#### Setup common properties

By using the method setElementDecorators() of Zend_Form, all default decorators are replaced by the ones specified. The decorators that fit my needs are ViewHelper (renders the element itself) and Description, resulting in:

<pre lang="php">protected function setupElementsCommon()
    {
         $this->form->setElementDecorators(array(
            'ViewHelper',
            array('Description', array(
                'placement' => 'append',
                'tag' => 'span',
                'class' => 'description'
            )),
         ));
    }
</pre>

#### Setup per-element properties

Here I add additional decorators. First I setup the element&#8217;s label and description properties by using the language pack, then I add the appropriate decorators. Furthermore I add some additional classnames to elements. If the element has an error I not only want to display the errors (using a custom decorator, more on that later). I also want to give the HTML element wrapped around all of the parts an &#8216;error&#8217; classname.

<pre lang="php">$elmHasError = (count($elm->getMessages()) > 0);
        $liClass = $elmHasError ? 'error' : '';
        $elm->addDecorator(
            array('outerLi' => 'HtmlTag'),
            array('tag' => 'li', 'class' => $liClass)
        );
</pre>

#### Setup the form object

Finally the Form is configured. After removing all existing decorators, three decorators are added. The only difference with the default set of decorators is the UL element used in the HtmlTag decorator:

<pre lang="php">protected function setupForm()
    {
        $this->form->clearDecorators();
        $this->form->addDecorator('FormElements');
        $this->form->addDecorator('HtmlTag', array('tag' => 'ul'));
        $this->form->addDecorator('Form');
    }
</pre>

### Adding a custom decorator

The complete code shows that instead of the default &#8216;Errors&#8217; decorator I provide my own. This way I can retrieve the error messages provided by the form element and then replace them with messages retrieved from the languagePack. A custom decorator needs to extend Zend\_Form\_Decorator\_Abstract or implement Zend\_Form\_Decorator\_Interface. Excerpts from [My\_Decorator\_Errors][8]:

<pre lang="php">public function render($content)
        $element = $this->getElement();
        $errorMessages = $element->getMessages();
        if (empty($errorMessages)) {
            return $content;
        }

        // iterate over errorMessages, replace or use default
        $errorLinesHtml = '';
        foreach ($errorMessages as $errorCode => $errorMsg) {
            // make an exception for isEmpty and array representing elements
            if ($element->isArray() && $errorCode=='isEmpty') {
                $msgLangPack = $this->lang->get('form.error.array.' . $errorCode);
            } else {
                $msgLangPack = $this->lang->get('form.error.' . $errorCode);
            }
            $errorMsg = ($msgLangPack !== false) ? $msgLangPack : $errorMsg;
            $errorLinesHtml .= '

<li>
  ' . $errorMsg . '
</li>';
        }
        // combine
        $errorHtml = '

<ul class="errors">
  ' . $errorLinesHtml .'
</ul>';

        // ...
</pre>

Errormessages are fetched by an element&#8217;s getMessages() method that returns an associative array. The error-codes (keys) can be used to translate the message. As can be seen I treat elements representing an array differently when fetching the &#8216;isEmpty&#8217; error message.

<div class="sidenote">
  <p>
    Why using a custom errors decorator and not setting the messages on the element?
  </p>
  
  <p>
    setErrors() can be used to set own errors on Zend_Form_Element. Those errors are stored in property _errorMessages which is indeed cleared first. This doesn&#8217;t remove the messages received from the validators though as they are stored in _messages. Upon adding an error by setErrors() both arrays are merged into _messages (this happens in markAsError()) and that&#8217;s the one returned by getMessages(). So trying to replace the existing isEmpty error by &#8216;setting&#8217; a custom error effectively adds an error instead of replacing it. getErrorMessages() does return just the new errors but&#8230; the viewHelper formErrors (which is invoked by the default &#8216;Errors&#8217; decorator) uses getMessages()&#8230;
  </p>
</div>

### Rendering the view mode

The view renderer is a simplified version of the edit renderer. Main differences are:

  * The form doesn&#8217;t have a Form decorator and thereby no form tag. (I&#8217;ll keep calling the no-form a form though ;)).
  * All elements have only one decorator common for all elements: My\_Decorator\_View_Element
  * As the only element decorator doesn&#8217;t use Zend_View, the form has no need for a View element.

#### My\_Decorator\_View_Element

This decorator retrieves value and label from the element and creates. It then creates HTML making exceptions for:

  * Submit elements (which are ignored)
  * Array representing elements (where more than one value needs to be displayed)

### Concluding

Above examples give an impression of how Zend_Form can be suited to virtually anyone&#8217;s needs. One can argue that separating the rendering from the basic definition adds unnecessary complexity. It does however pull HTML specifics (which during a project life-cycle often are subject to change) out of the &#8216;model&#8217; layer. Both the stripped down forms and renderers are easy to reuse: The renderer can be applied to a number of forms and the forms themselves can be used in projects requiring different HTML.

Even without considering the rendering part, Zend\_Form is a valuable platform offering a lot of ways to customize it. As the view renderer example shows it can also operate without Zend\_View, provided one doesn&#8217;t use any of the built in decorators. Being able to provide self-built elements, validators and decorators makes it possible to use Zend_Form in virtually any project.

Further reading:

  * [Zend Framework API documentation][9]
  * [Decorators with Zend_Form][10]
  * [Rendering Zend Form decorators individually][11]
  * [Advanced Zend_Form usage][12]

 [1]: http://framework.zend.com/
 [2]: http://framework.zend.com/manual/en/zend.form.html
 [3]: /static/zend_form_without_mvc/
 [4]: http://github.com/TBeijen/Zend_Form_Without_MVC
 [5]: http://framework.zend.com/manual/en/zend.view.helpers.html
 [6]: http://framework.zend.com/manual/en/zend.validate.html
 [7]: http://github.com/TBeijen/Zend_Form_Without_MVC/blob/master/htdocs/My_Form_Renderer_Edit.php
 [8]: http://github.com/TBeijen/Zend_Form_Without_MVC/blob/master/htdocs/My_Decorator_Errors.php
 [9]: http://framework.zend.com/apidoc/core/
 [10]: http://devzone.zend.com/article/3450
 [11]: http://weierophinney.net/matthew/archives/215-Rendering-Zend_Form-decorators-individually.html
 [12]: http://giorgiosironi.blogspot.com/2009/10/advanced-zendform-usage.html