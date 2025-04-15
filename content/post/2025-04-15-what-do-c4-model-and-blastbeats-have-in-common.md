---
title: "What do the C4 architectore model and blastbeats have in common?"
author: Tibo Beijen
date: 2025-04-15T05:00:00+01:00
url: /2025/04/15/what-do-c4-model-and-blastbeats-have-in-common
categories:
  - articles
tags:
  - C4
  - Architecture
  - Software
  - Music
description: 
thumbnail: 

---

Past Friday I had a focus day, hardly any meetings and time to do some scheduled deep work. Also, Fridays in general are 'release day', which always means anticipating on new album drops[^footnote_albums]. This Friday saw the luxury of two excellent new albums being released: Biographyte by Cytotoxin and Aspiral by Epica. Both albums where 'a lot is happening'.

For a bit of context: I work as a consultant, architect, engineer and everything in between in tech. So part is meetings, part is more hands-on, requiring focus. In my teens, acts like Guns'n'Roses and Metallica have been gateways into more extreme types of music. So, these days I listen to bands incorporating elements deemed inaccessible by many: [Blastbeats](https://en.wikipedia.org/wiki/Blast_beat), cookie monster vocals and speeds well over 240bpm[^footnote_280bpm]. I played some guitar so consider myself a guitar-nerd. I'm also a drum-nerd but never played drums. Simply put: I don't have the chops to play to music I listen, and don't have the time to acquire them[^footnote_practice]. Doesn't stop me from enjoying it though!

Many times I have wondered (and so have others) how it is possible that I can focus on work while listening to music that is, let's be frank, quite intense. After all, there are also people that need ambient sound to be able to focus.

Pondering that during my weekend run, it struck me that I focus on music at different levels of details, very similar to how I switch between more engineering and more architectural perspectives.

## The bands

TODO

## The C4 model, translated to music

The [C4 model for visualising software architecture](https://c4model.com/) recognises four levels:

* Level 1: Context (system). Zoomed out. Takes a system, your system, as starting point and puts it in the context of other systems and users
* Level 2: Container. Shows the runnables/deployables of the system.
* Level 3: Component. Shows how a container is made up of components and responsibilities and technology details of those components
* Level 4: Code. Implementation details, using UML class diagrams and entity relationship diagrams.

The exact boundaries are not that important. The general gist is it goes from coarse to fine-grained. Now let's translate that to music:

* Level 1: Genre. The elements that put music in a certain genre.
* Level 2: Song. Composition. Structure. Atmosphere. Recognisability.
* Level 3: Components. Think: Riffs, Melodies, Hooks, Instruments.
* Level 4: Technique. Tapping (guitar). Double bass (drums). The list is endless....

Let's explore these detail levels of music some more. This works best when starting at the most detailed level: Technique.

## The 4 levels

### Technique (level 4)












* Genre: 
* Song: 
* Composition
* Detail level. 



* Goes from regular blastbeat, to gravity blast, to half-time with 16th kicks, to regular thrash beat. All while guitars are doing 3-3-3-3-4 patterns over a 4/4 beat (Hope Terminator).
* Hey, this riff is more thrash-influenced than they've done so far. (The Everslave at the ~1:30 mark)
* Interesting how they seamlessly go from a burst of aggression, blastbeats and bombast, back to the earworm chorus (The Grand Saga of Existence, from 5:10)
* Funny, how Cytotoxin is mostly hyperspeed blastbeats, using slower more groove-oriented parts as accents, whereas Epica is more accessible and slower, yet using fast parts as accents.

## The parallels

For both architecture and music, one could say that all levels have their specific purpose and are complementary.

Focusing merely on code, or technique, one is bound to get lost in details that have no purpose. Code that grows in complexity without filling a need. Rabbit holes that would better have been evaded than dived into. In music this would translate to technical noodling without any memorable song, hook or melody. A flurry of notes that will be forgotten the moment it stops. Quite some technical death metal falls in this category.

Similarly, if focus stops at the system level, one might end up with plans that are impossible to execute. Boxes and arrows that look logical, but under the surface, embody clunky interfaces, slow and complex processes, or a myriad of cross-team dependencies. It's the lower level details that define if an API is easy to implement, software provides a good user experience, or a component is fault-tolerant, scalable and performant. The musical equivalent would be uninspired formulaic songs that tick all the genre-boxes but are utterly uninspired and not memorable. Piq-squeels? Check. Breakdowns? Check. Downtuned chugga-chugga? Check. Boring? Check.

Chaos and details become meaningful in a context. Plans succeed or fail based on details.

For both software and music there are aspects not covered by the model. They are more in the area of quality attributes. Does the system we are building have a meaningful purpose? Do artist theatrics hide a lack of musical substance? Is the artist by any means credible? The [lyrics of 'The sound of Muzak'](https://metalstorm.net/bands/lyrics.php?album_id=2330&bandname=#6155) by Porcupine Tree spring to mind:

> The music of rebellion, makes you wanna rage. But it's made by millionaires, who are nearly twice your age

Probably this article won't change anyone's taste of music. And probably also not one's approach to software architecture and engineering.

But there is hopefully one take-away: Be it creating music or software: Don't limit your focus to just one level!

[^footnote_albums]: Telling my age without telling my age. Yes, I listen to full albums.

[^footnote_280bpm]: The good thing about the 260-280bpm speed range is, that if you go half-time, all your dance-floor skills still apply.

[^footnote_practice]: Assuming that would depend only on practice, and not on talent. Maybe when the kids grow older and arthritis hasn't yet got a foothold.