# Holiday Sweater Contest App 🎄:santa:

This web app is a virtual ugly holiday sweater contest. Anyone can upload a picutre of their sweater, and then other users will vote if the sweaters are naughty or nice.

**[Play with it now!! Live Demo!](https://holidaysweater.app)**

## The Team Who Made It
- Marcus Twichel - [Github](https://github.com/mtwichel) | [Twitter](https://twitter.com/mtwichel)
- Bruce Clark - [Github](https://github.com/bruceclark406) | [Twitter](https://twitter.com/BruceClark406)

## How We Made It
This project is made with Flutter Web on the frontend and Supabase on the backend.

### Backend
In Supabase, we specifically used:
- Auth with Google
- Storing image metadata and ratings in the Postgres Database and accessing them with PostgREST
- Storing image files in Storage


When you visit the site (after signing in), you pull 15 images to your device. These are randomly selected as photos you have not yet rated and are not your photos (all determined by your auth uid). We accomplished this with a custom stored procedure in Supabase that is called using its PostgREST endpoint.

We also wanted to randomly order the images, but we wanted that random ordering to be unique accross users, yet consistent for each individual user (ie my order is different than yours, but it's the same every time I visit the site). We accomplished this by ordering the entries by a hash of the `photoId` using the `userId` as the hashing key. We did this all in the stored procdure using `pgcrypto`, which is built in to Supabase by default.

```sql
ORDER BY
  encode(
    hmac(
      p.id::text,
      userId::text,
      'sha256'
    ),
    'base64'
  )
```

When you rate an image, the rating is added to a `ratings` table. We then use a custom view to group by each `photoId` and count the number of nice entries and the number of naughty entries.

### Frontend
We used Flutter Web for the frontend. It allowed us to make dynamic animations and quickly prototype while also delivering a high-quality experience.

The home page (where you rate the photos) was particularly tricky because we 1) wanted the background to fade into green/red as you swiped left or right, and 2) wanted an animation to take over and finish swiping for you if you moved the image far enough. However, due to the nature of Flutter, we were able to accomplish this by using a `GestureDetector` that detected your finger movement left and right, and also when you released the image. When moving side to side, we updated the widget state compute what color should be rendered, and started an animation from your current finger position to a position off screen when you released.

---
Made with 💙 by [Morel Technologies](https://morel.technology) for the [Supabase Holiday Hackathon](https://www.madewithsupabase.com/holiday-hackdays)

