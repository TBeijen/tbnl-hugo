---
title: Explicit PHP6?
author: Tibo Beijen
layout: post
date: 2009-06-11T07:47:06+00:00
url: /blog/2009/06/11/explicit-php6/
postuserpic:
  - /pa_php_80.jpg
categories:
  - articles
tags:
  - oop
  - php
  - php6

---
Some days ago I read Fabien Potencier&#8217;s post [&#8216;What for PHP 6&#8217;][1] pointing me to some features that might be implemented in PHP6. Two of those would have been nice in a project I&#8217;m currently working on where I&#8217;ve been experimenting with &#8216;domain objects&#8217; having &#8216;scalar&#8217; or &#8216;value&#8217; objects as properties (more on that later). The first is scalar type hinting and hinted return values. The other is a \_\_cast() method that replaces (or complements \_\_toString()). Now that sounds quite java-ish and one of PHP merits is it&#8217;s flexibility but having the _option_ to be more strict in my opinion is a good thing: If I feed my application with garbage I don&#8217;t blame it for being equally blunt.
  
<!--more-->


  
Consider a User object that has the properties userid, email and admin. 

<pre lang="php">class User
{
    protected $userId;
    protected $email;
    protected $admin;

    public function setUserId(UserId $userId) {}

    public function setEmail(Email $email) {}

        // this should only accept a boolean
    public function setAdmin($isAdmin) 
    {
        if (!is_bool($isAdmin)) {
            throw new ValueTypeException(
                'Wrong parameter for ' . __METHOD__
            );
        }
        $this->admin = $isAdmin;
    }
}
</pre>

Here being able to enforce the boolean parameter would be nice and more consequent with the other methods.

The Email value object has it&#8217;s own validation and could look like this:

<pre lang="php">class Email
{
    private $value;

    public __construct($value)
    {
        if (!preg_match('/^.+\@.+\..+$/',$value) {
            throw new ScalarValueException(
                'Invalid value for type Email'
            );
        }
        $this->value = $value;
    }

    public function __toString()
    {
        return $this->value;
    }
}
</pre>

Now let&#8217;s look at how a PHP6 UserId object _might_ look like:

<pre lang="php">class UserId
{
    private $value;

    public __construct($value)
    {
        $isValid = true;
        if (!is_int($value) ||
            !$this->exists($value) ||
            $value &lt;=0
        ) {
            throw new ScalarValueException(
                'Invalid value for type UserId'
            );
        }

        $this->value = (int) $value;
    }

    // Warning: uses PHP6 proposed features
    public function __cast($type)
    {
        if ($type == 'int') {
            // return integer value
            return $this->value;
        }
        if ($type == 'boolean') {
            // return true as UserId can only 
            // exist with a valid value
            return true;
        }
        throw new SkalarInvalidCastException(
            'Object of type UserId cannot be cast to '.$type
        );
    }

    private function exists($value)
    {
        // method that checks if a user with given id exists
    }
}
</pre>

As can be seen the \_\_cast() method assumably (it&#8217;s just a proposed feature) accepts a $type parameter. That raises the question if it wouldn&#8217;t be better to add \_\_toInteger(), \_\_toFloat() and \_\_toBoolean() methods instead. That seems more consequent with the __toString() method that&#8217;s allready widely used.

The C#-style properties with getters and setters might be nice too, although imho it doesn&#8217;t really add much to the allready existing \_\_set() and \_\_get() methods. I would prefer to see &#8216;strongly typed&#8217; properties instead:

<pre lang="php">class User
{
    // PHP6 wishlist: strong typed properties
    protected UserId $userId;
    protected Email $email;
    protected boolean $admin;

    // etc...
}
</pre>

I&#8217;m really looking forward to these kind of additions, especially if such type hinting is kept optional. Then the flexibility of PHP is preserved but it allows for a more robust approach in large projects.

Be explicit. Type strong.

 [1]: http://fabien.potencier.org/article/18/what-for-php6