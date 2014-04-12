Space-Apps
==========

Team TWG's Space Apps Project


## Judging Factors

- Impact
- Creativeness
- Sustainability
- Presentation

### Earth-Shattering Asteroid Characteristics

**Abundant**
- Iron - Fe
- Carbon - C
- Silicon - Si

**Common**
- Water - H2O
- Nickel - Ni
- Cobalt - Co
- Titanium - Ti
- Magnesium - Mg

**Scarce**
- Platinum - Pt
- Gold - Au
- Silver - Ag

### Primary Asteroid Types (Source: [Asteroid Mining] (http://en.wikipedia.org/wiki/Asteroid_mining)) ###
1. **C-type** (most common) asteroids have a high abundance of water which is not currently of use for mining but could be used in an exploration effort beyond the asteroid. Mission costs could be reduced by using the available water from the asteroid. C-type asteroids also have a lot of organic carbon, phosphorus, and other key ingredients for fertilizer which could be used to grow food.
2. **S-type** carry little water but look more attractive because they contain numerous metals including: nickel, cobalt and more valuable metals such as gold, platinum and rhodium. A small 10-meter S-type asteroid contains about 1,433,000 pounds of metal with 110 pounds in the form of rare metals like platinum and gold.
3. **M-type** asteroids are rare but contain up to 10 times more metal than S-types

### Storyboard

#### Intro ####
1. Alert!!!
2. [On Screen]Professor "Faisal Shahbaz" - Astronomer from the Near Earth Object Program 
3. We've detected a 2km wide asteroid hurtling towards us at 50,000km/h! If we don't do something fast this asteroid will wipe out all life on earth!
4. Fortunately, your asteroid mining team is already in the area.  It's up to you to save the planet.  Use your mining equipment to break up the asteroid into smaller pieces so that they burn up in the atmosphere.
5. You better hurry though, even though the asteroid is still 1250km away you only have 90 seconds before it impacts earth!
6. One more thing, as a thank you for saving the planet, we're going to let you keep any resources that you find while mining.
7. Now hurry up and start drilling already!

#### User Drilling Screen ####
- Notifcations appear as resources are mined
  - On main screen or ipad interface or both?
  - Use an ingot or rock image with the element symobl dynamically added inside as an icon?
- Units are kg
- Multiplier of probability applied based on scarcity to determine which resources are mined (Abundent, Common, Scarce resources from table above)

#### End of Game - Sucess ####
1. [On Screen]Professor "Faisal Shahbaz" - Astronomer from the Near Earth Object Program
2. Phew!  You saved us all, that was a close one.  It took you [time taken] seconds to break apart the asteroid at a distance of [ (90s - time taken) x 13888.9m/s]/1000m/km ].  Another [90s - time taken] and we would have been done for!
3. As a thank you for saving the entire human race, we're going to let you keep all the resources you mined!

#### End of Game - Failure ####
1. Game Over
2. You weren't fast enough and life on earth has been completely wiped out.
3. Oh well, at least you still have all the resources you mined...

#### End of Game - Stats ####
- Stats showing who mined what resources
- Scarce resources are worth more points
- Fun awards for things like fastest button tapper, most kg mined, most scarce resources mined, etc...
- Play again?


=======
## JSON Formats

### Action
```
{
  "action":"drill",
  "deviceID":"1"
}
```
