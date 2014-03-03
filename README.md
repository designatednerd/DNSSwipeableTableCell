DNSSwipeableTableCell
====
----

This is an extension of a tutorial I've written for [RayWenderlich.com](http://www.raywenderlich.com) on how to create a swipeable UITableViewCell for iOS 7 without driving yourself completley insane with UIScrollViews. (Drive yourself insane with constraints instead!)

The crux of the problem is that while adding a delete button is super-easy, adding a delete button AND another button is a total nightmare because of the way the cells are constructed. 

I've refactored the code that was included in the tutorial, which is is more meant as an exercise in helping noobs dive into figuring out how Apple's code works under the hood, into this library, which I'm hoping will be helpful for anyone dealing with this in production code. 

##The Biggest Changes
* Beefed up delegate to handle an arbitrary number of buttons
* Added datasource to allow tons of user-configurable options
* Added a ton of documentation to the swipeable cell class
* Cleaned up the master VC quite a bit

##TODOs
* [Figure](id:footnote1) out a way to not have to store the index path on the cell itself. It's way easier, but it feels dirty.([1](#footnotes))
* Add a more configurable main content view that can still be recycled, or at least add instructions and an example for subclassing to achieve this. 
* Remove dependency on setting up some of this stuff in a storyboard. 

---
([1](id:footnotes)): [I know, I know](http://shirt.woot.com/offers/she-is-reported-to-have-said-that-before). ([<-](#footnote1))