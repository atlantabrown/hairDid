<Name: Atlanta Brown>
<Name of project: HairDid>
<Dependencies: Xcode 13.1, Swift 5.5>

#Instructions#
<You have to open the file hairDid.xcworkspace (as opposed to the file hairDid.xcodeprog).>
<Before running the app, run "pod install" inside the DragonWar folder where the podfile is located>
<preferred to be ran on an iphone 11 pro Max>

#Features#
ui - <A splash screen, color theme, logo, buttons, tab bar navigation, compatiable across devices, sleek forms to enter user information, and an aestehtic settings menu>
login - <Both clients and users can sign up for an account. They can log out and log back in within the same session of the app running>
database - <User information can be saved, edited, and updated>
picture picker - <Provider can demonstrate an example of their work by uploading a picture that persists to the database>
settings - <can share application, about page>


#Deviations & how I would've implemeted them# 
* Didn't implement ability to swipe through provider's profiles:
    >Still not entirely sure how I would've gone about this. I format the provider's profile another time in the code, so I would restructure that so it would be reusable. 
    >I would loop through the providers in Firebase and add them to the formatting 
    >I would load the upcoming providers so the user has profiles ready to swipe 
    >I would more deliberately plan when data that will be used soon is loaded
    >e.g. Maybe while the client is in settings editing thier profile, all of the provider profile data would be grabbed from the database  

* Client like list that had all the provider's information to reference: 
    >would've done this with protocols & delegates and a class for the providers similar to how we did the pizza homework
    >this feature was reliant on the previous one 
    
* Changed the settings I decided to implement: 
    >I learned a little bit too late that using storyboard introduced a lot of issues, and while I was able to redo most of the code programmatically, storyboard is still apart of what I have right now 
    >I think the share setting is useful and it aligned better with how my project is set up 



