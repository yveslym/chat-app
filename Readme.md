# Chat App

This challenge had three requirements:

* send text messages
* send audio messages
* send picture messages

Another related requirement was to login users using Facebook's account kit with Firebase as our database.

I completed all the requirements for this challenge. I also implemented a push notification using Firebase Cloud Messaging and Firebase function (as server) which sends the notification to the appropriate user when a new message object is created.

Beside Facebook's SDK and Firebase, I also used these libraries:

* _MessageKit_: To render the message collectionview
* _Kingfisher_: To load images
* _SwiftIcons_: For icons

### Issue:
During this challenge, I faced a couple of challenges:
1. Chat App: I used firebase for many projects, as well as Facebook's SDK, so the integration of those two in the project was quite straightforward. However, when it came to implement the chat view controller, that was my first time doing so. 
2. Rendering audio view on the message cell: MessageKit doesn't support audio messages, thus I had to make a custom view for the audio message.
3. Using URL to load messages: MessageKit offers a method to load image messages with URLs, but for some reason it didn't work; I had to work around it.

### What could have been done better:

Saving the picture in cache memory to retrieve it faster would have been an appropriate optimization.

The UI is pretty basic, but I mostly focused on functionality.