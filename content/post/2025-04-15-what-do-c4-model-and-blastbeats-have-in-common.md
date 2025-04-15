---
title: "What do the C4 architecture model and blastbeats have in common?"
author: Tibo Beijen
date: 2025-04-15T05:00:00+01:00
url: /2025/04/15/what-do-c4-architecture-model-and-blastbeats-have-in-common
categories:
  - articles
tags:
  - C4
  - Architecture
  - Software
  - Music
  - Metal
description: The mind wanders while running. Are there parallels between creating software and listening to music?
thumbnail: img/c4_blastbeats_header.jpg

---

Past Friday I had a focus day, hardly any meetings and time to do some scheduled deep work. Also, Fridays in general are 'release day', which always means anticipating on new album drops[^footnote_albums]. This Friday saw the luxury of two excellent new albums being released: [Biographyte by Cytotoxin](https://cytotoxin.bandcamp.com/album/biographyte) and [Aspiral by Epica](https://epicaofficial.bandcamp.com/album/aspiral). Both albums where 'a lot is happening'.

For a bit of context: I work as a consultant, architect, engineer and everything in between in tech. So part is meetings, part is more hands-on, requiring focus. In my teens, acts like Guns'n'Roses and Metallica have been gateways into more extreme types of music. So, these days I listen to bands incorporating elements deemed inaccessible by many: Blastbeats, cookie monster vocals and speeds well over 240bpm[^footnote_280bpm]. I played some guitar so consider myself a guitar-nerd. I'm also a drum-nerd but never played drums. Simply put: I don't have the chops to play the music I listen to, and don't have the time to acquire those chops[^footnote_practice]. Doesn't stop me from enjoying it though!

Many times I have wondered (and so have others) how it is possible that I can focus on work while listening to music that is, let's be frank, quite intense. After all, there are also people that need ambient sound to be able to focus. Different people. Different needs.

Pondering that during my weekend run, it struck me that I focus on music at different levels of details, very similar to how I switch between more engineering and more architectural perspectives in my work.

{{< figure src="/img/c4_blastbeats.jpg" title="The C4 model accompanied by albums that provide plenty of layers as well" >}}

## The bands

A quick introduction of the two bands I am analysing here as a software architect. 

[Epica](https://www.epica.nl/band/) is a Dutch band, formed in the early 2000s. They are of the (broad) genre female-fronted metal and mix classical arrangements, complex song structures and bombast. At the same time they sometimes venture into levels of aggression, mostly the speed and vocal style, that sets them far apart from more accessible acts in the genre such as Within Temptation or Nightwish.

[Cytotoxin](https://www.cytotoxin.de/) describes themselves as 'Chernobyl Death Metal'. The theme is dark, and the sound is frantic. What (in my opinion) sets them apart from a lot of their technical counterparts, is their ability to create memorable songs and albums. It's a lot of notes. But not a blur. In that regard, together with [Archspire](https://archspire.bandcamp.com/album/bleed-the-future), they're a unique blend of chaos and hooks.

## The C4 model, translated to music

The [C4 model for visualising software architecture](https://c4model.com/) recognises four levels:

* Level 1: Context (system). Zoomed out. Takes a system, your system, as starting point and puts it in the context of other systems and users
* Level 2: Container. Shows the runnables/deployables of the system.
* Level 3: Component. Shows how a container is made up of components and responsibilities and technology details of those components
* Level 4: Code. Implementation details, using UML class diagrams and entity relationship diagrams.

The exact boundaries are not that important. The general gist is it goes from coarse to fine-grained. Now let's translate that to music:

* Level 1: Genre. The elements that put music in a certain genre and production characteristics. But also: Album.
* Level 2: Song. Composition. Structure. Atmosphere. Recognisability.
* Level 3: Components. Think: Riffs, Melodies, Hooks, Instruments.
* Level 4: Technique. Technicalities employed by the musicians.

Let's explore these detail levels of music some more. This works best when starting at the most detailed level: Technique.

## The 4 levels

### Technique (level 4)

This is where the music nerd comes to life. We have two-hand tapping. Tremolo picking. Whammy bar (ab)use. Drummers doing double bass at crazy BPMs using heel-toe or swivel. Hammer blasts. Gravity blasts. Dirk blasts. The list is endless.

Software equivalent would be things like python contexts, or Go channels.

### Components (level 3)

At the music component level one might think of things like: This riff sounds more thrash-influenced than they used before ([The Everslave](https://cytotoxin.bandcamp.com/track/the-everslave) around the 1:30 mark). Or, the second piccolo snare is still there, although not as prominent as on their previous album. This melody is stuck in my head. Nice how they vary on this main riff. Interesting how they go from regular blastbeat, to gravity blast, to half-time with 16th kicks, to regular thrash beat, all while guitars are doing patterns of 3 over a 4/4 beat ([Hope Terminator](https://cytotoxin.bandcamp.com/track/hope-terminator-2)).

In software this would be classes, modules and packages.

### Song (level 2)

Here we focus more on the compositions. For example song structure, is it traditional verse chorus with a short runtime? Or is the structure more complex, gradually building up to a climax? Take the build-up of 'The Phantom Agony'. But also the complex structure and intricate riffing in alternating 5-5-3 and 5-5-4 patterns in [Façade of Reality](https://open.spotify.com/track/1MnQbPlaRb33PYj8JkYZ0p?si=7fc69e48cf004f4f)[^footnote_phantom_agony]. (Give me odd time signatures and I start counting!)

What dynamics does a song have? What interesting turns does it take? It's amazing how [The Grand Saga of Existence](https://open.spotify.com/track/6JJMwYkssIj8jjW5OyAoSo?si=995fc05fa86f4d6d), from around 5:10 explodes in a burst of bombast and blasts, only to turn back into an earworm chorus within a couple of bars.

In software, we would be talking deployables, scaling and the likes.

### Genre (level 1)

Finally we arrive at the most coarse level: The genre. The overall sound. The album. 

Are there any fillers on an album that would better have been left out? Or songs that don't fit? Is a band's sound unique? Take for example [Obsidian Heart](https://open.spotify.com/track/4ULuGrko8xKdiH7QWUyJKL?si=ab38d2afa96a4d17) with it's bouncy bass sound that puts it a bit in the Djent genre, while still fitting on the album.

Also in this category I find it an interesting observation that both Epica and Cytotoxin have parts that are perhaps a bit much for the casual listener. But they take quite an opposite approach. Epica takes melody as a starting point, accented by venturing into up-speed aggressive parts. Cytotoxin's baseline is 'much of everything' and then ventures into hooks and breakdowns that give a bit of relief.

In software we would be focusing on DDD concepts, API contracts or broad concepts like event-driven architectures.

## The parallels between software and music

For both architecture and music, one could say that all levels have their specific purpose and are complementary.

Focusing merely on code, or technique, one is bound to get lost in details that have no purpose. Code that grows in complexity without filling a need. Rabbit holes that would better have been evaded than dived into. 

In music this would translate to technical noodling without any memorable song, hook or melody. A flurry of notes that will be forgotten the moment it stops. Quite some technical death metal falls in this category.

Similarly, if focus stops at the system level, one might end up with plans that are impossible to execute. Boxes and arrows that look logical, but under the surface, embody clunky interfaces, slow and complex processes, or a myriad of cross-team dependencies. 

It's the lower level details that define if an API is easy to implement, software provides a good user experience, or a component is fault-tolerant, scalable and performs well under load. 

The musical equivalent would be uninspired formulaic songs that tick all the genre-boxes but are utterly uninspired and not memorable. Piq-squeels? Check. Breakdowns? Check. Downtuned chugga-chugga? Check. Boring? Check.

Interesting music might provide a seeming excess of notes and layers of instruments. But they derive meaning from the grooves, chord progressions and dynamics they are used in.

Chaos and details become meaningful in a context. Plans succeed or fail based on details.

For both software and music there are aspects not covered by the model. They are more in the area of quality attributes. Does the system we are building have a meaningful purpose? Do artist theatrics hide a lack of musical substance? Is the artist by any means credible? 

The [lyrics of 'The sound of Muzak'](https://metalstorm.net/bands/lyrics.php?album_id=2330&bandname=#6155) by Porcupine Tree spring to mind:

> The music of rebellion, makes you wanna rage. But it's made by millionaires, who are nearly twice your age

Probably this article won't change anyone's taste of music. And probably also not one's approach to software architecture and engineering.

But there is hopefully one take-away: Be it creating music or software: Don't limit yourself to a single perspective!

[^footnote_albums]: Telling my age without telling my age. Yes, I listen to full albums.

[^footnote_280bpm]: The good thing about the 260-280bpm speed range is, that if you go half-time, all your dance-floor skills still apply.

[^footnote_practice]: Assuming that would depend only on practice, and not on talent. Maybe when the kids grow older and arthritis hasn't yet gotten a foothold...

[^footnote_phantom_agony]: Ok, I've listened to the Phantomy Agony way more than Aspiral.