# Skyline
​
## Description 
​
Ever wish you could explore Rijksmuseum's art work and also look for fun events on Ticketmaster on the same app? No? Ok well it's because you could never imagine such an amazing combo but now you can!
Skyline lets you select a view, Art or Events, and from there your experience begins. If you select "Events" you get access to millions of tickets no matter where you are. Simply search by city or postal code and get a list of events nearby. You can view event details and if interested directed to the ticketmaster website to purchase tickets! If you choose "Art" you get to visit the Rijksmuseum from home. Discover works or art by simply searching from the comfort of your home (or where ever you are) and even get access to the art works details. 
What ever the experience, you can favorite and save items directly on the app and log in anywhere to access your favorites. You can even change your experience in settings and go back and forth, no limits!
​
**bold** 

## Frameworks & Packages
- Firebase Auth to manage account creation and signing in.
- Firebase Firestore to manage user accounts and the items that have been favorited.
- [Kingfisher CocoaPods](https://cocoapods.org/pods/Kingfisher)
- [Swift packages](https://github.com/alexpaul/ImageKit) (Shout out to Alex!)
​
## APIs

Ticketmaster -> discovery API](https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/) to load all events at a location that the user searches for. 
Rijksmuseum -> [Collection API](https://data.rijksmuseum.nl/object-metadata/api/) to load all museum items from a name that the user searches for, and their [Collection Details API](https://data.rijksmuseum.nl/object-metadata/api/) to load additional information about the select item including its plaque Description in English, its date it was created, and the place it was produced. Kijk uit voor dit schilderij "de nachtwacht." 

