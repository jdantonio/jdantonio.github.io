---
title: "Size Cards First, Then Do Everything Else"
layout: post
tags: [agile]
date: 2015-09-18 10:19:18 EDT
comments: true
share: true  
image:
  feature: russia-journal-narrower.png
---

Once upon a time I worked with a team that was trying to transition from waterfall to agile. They were a smart, talented, and well-intnetioned group. They were also on the fast train to failure. Our big problem was that the team leaders were doing the transformation backwards. They wanted to make the transition in "manageable" steps. Their plan was simple:

1. Begin defining the work as [user stories](http://www.agilemodeling.com/artifacts/userStory.htm) rather than feature requests
2. Later, add [sprint planning](https://www.mountaingoatsoftware.com/agile/scrum/sprint-planning-meeting) to the process
3. When ready, begin regular [backlog grooming](http://guide.agilealliance.org/guide/backlog-grooming.html) sessions
4. Finally, add [card sizing](http://scrummethodology.com/scrum-effort-estimation-and-story-points/) to the mix

Unfortunately, this was entirely backwards. Card sizing should have come *first*. It's a necessary step even when the work list isn't *proper* story cards. And that's why we had so many problems.

One of the objections to card sizing was a concern that business would see the sizes as delivery dates. Card sizing has nothing to do with time. It's about complexity (and [dinosaurs](/images/dinosaur_sizes.pdf), but that's another post). Despite popular belief, accurate velocity and delivery estimation are *side effects* of card sizing. The real value of card sizing is *discovery*.

The first rule of card sizing is that everyone participates in card sizing. It doesn't matter which [methodology](http://www.sitepoint.com/3-powerful-estimation-techniques-for-agile-teams/) you use (though I'm partial to [dinosaurs](/images/dinosaur_sizes.pdf)), it's critical that everyone have an equal say. Even the newest members of the team and the most junior developed. Especially the newest members of the team and the most junior developers. Their involvement is critical, specifically because they know the least about the project.

There is a famous saying, often referred to as [Linus's Law](https://en.wikipedia.org/wiki/Linus%27s_Law), that "given enough eyeballs, all bugs are shallow." The same is definitely true about story cards: given enough input, all bad requirements are shallow. And this is exactly what happens during card sizing: holes in the requirements rise to the surface and immediately get filled.

There is a common misperception in agile circle that the best people to write story cards are the domain and product experts. Nothing could be further from the truth. These are the worst people to write the cards. Their expertise causes them to leave out many critical details. They incorrectly assume that everyone has the same knowledge as they do, which is never the case. This causes cards to lack sufficient detail and critical analysis. Put that card in front of the newest team member and ask them to estimate the card's complexity, and that lack of detail will immediately become apparent.

> Jr. "Won't we need a set of factories and configurators to make this work?"
>
> Sr. "No, we already have those. They're in library XYZ."
>
> Jr. "Cool! Please add that to the card."

> Newbie: "Is that information in the 'customer' model already?""
>
> Veteran: "It's good that you asked! It's a long story, but the Customer model actually maps to the 'customer profile' table. We'll need to change that."
>
> Newbie: "That's going to be important. Please add it to the card."

> UX: "It's becoming a common practice to do that asynchronously to avoid pausing the UI. Have we taken that into account?"
>
> PO: "I wan't aware of that. We should to it that way."
>
> UX: "Great. Let's add that to the card so that it isn't forgotten later."

And on and on and on...

The process of card sizing *forces* a deeper and more meaningful discussion of each and every card than will ever happen in a room full of experts. Scope creep is disturbingly common when cards aren't properly sized, simply because so many details are missed. More importantly, the *impact* of scope creep is never felt when cards aren't sized. New requirements can be added to cards ad infinitum with impunity. And the team suffers. When cards are properly sized, every scope change requires that the card be sized again.

And this is why card sizing needs to be the **first** task added to an nascent agile process. Inexperienced teams have a tendency to start by writing cards but then do it poorly, specifically because of their inexperience. Sizing cards **forces** the team to write good cards, even when they don't know what constitutes a "good" card.

So this team I worked on, despite being smart, talented, and well-intentioned, continued to struggle with poorly written cards, ill-defined requirements, and scope creep. Thus indefinitely delaying their adoption of the one practice that would have immediately turned things around.
