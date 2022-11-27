# Recipe API

## 1:Run the app
Run the app.
DB setup will be taken care of.

```
docker-compose up
```

## 2:Set up the database

Set up the database when you run the app for the first time.

```
docker-compose run app rails db:setup
```

## 3:Create a session

Create a session to get an access token by calling POST /sessions with user information.
Access token will be used for authentication.

`POST /sessions`

```
curl -X POST -H "Content-Type: application/json" -d '{"email":"<EMAIL>", "password": "<PASSWORD>"}' http://localhost:3000/sessions
```

## 4:Call endpoints

Call the endpoints with the access token you made at step 3.
Here is an example of calling the endpoint to get recipes.

`GET /recipes`

```
curl -H "Content-Type: application/json" -H "Authorization: Token <ACCESS_TOKEN>" http://localhost:3000/recipes
```
