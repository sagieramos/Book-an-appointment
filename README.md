<!-- TABLE OF CONTENTS -->

# 📗 Table of Contents

- [📗 Table of Contents](#-table-of-contents)
- [📖- ✅ HELLO-REACT-FRONT-END](#---hello-react-front-end)
  - [🛠 Built With ](#-built-with-)
    - [Tech Stack ](#tech-stack-)
    - [Key Features ](#key-features-)
  - [💻 Getting Started ](#-getting-started-)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
    - [Usage](#usage)
      - [Auth Sign up](#auth-sign-up)
      - [Auth Login](#auth-login)
      - [Retrieve reservations that is associated with a user](#retrieve-reservations-that-is-associated-with-a-user)
      - [Retrieve items that is associated with a user](#retrieve-items-that-is-associated-with-a-user)
      - [Make user an Admin](#make-user-an-admin)
      - [Remove user from Admin](#remove-user-from-admin)
      - [Retrieve all Items](#retrieve-all-items)
        - [Data](#data)
        - [Meta](#meta)
        - [Client Customization](#client-customization)
    - [Request type: POST](#request-type-post)
      - [Request type: PATCH](#request-type-patch)
    - [Deployment](#deployment)
  - [👥 Authors ](#-authors-)
  - [🔭 Future Features ](#-future-features-)
  - [🤝 Contributing ](#-contributing-)
  - [⭐️ Show your support ](#️-show-your-support-)
  - [🙏 Acknowledgments ](#-acknowledgments-)
  - [📝 License ](#-license-)

<!-- PROJECT DESCRIPTION -->

# 📖- ✅ HELLO-REACT-FRONT-END

**hello-react-front-end**

## 🛠 Built With <a name="built-with"></a>

- ✅ React

### Tech Stack <a name="tech-stack"></a>

<details>
  <summary>Language</summary>
  <ul>
    <li>JavaScript</li>
  </ul>
</details>

<!-- Features -->

### Key Features <a name="key-features"></a>

- 🔰 **Static view**
- 🔰 **Display API response**


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## 💻 Getting Started <a name="getting-started"></a>

**To get a local copy up and running, follow these steps.**

1. Download or clone this [repostory](https://github.com/sagieramos/hello-react-front-end).
2. Provide a modern web browser.

### Prerequisites

**In order to run this project you need:**

- ✔ Ruby installed in your machine. you can download it from [here](https://www.ruby-lang.org/en/downloads/)
- ✔ IDE or a code editor installed in your machine.
- ✔ A professional editer such as [VS Code](https://code.visualstudio.com/download).
- ✔ An Updated web browser such as Google Chrome, you can download it from [here](https://www.google.com/chrome/).

### Setup

- Clone this [repository](https://github.com/sagieramos/hello-react-front-end) to your desired folder:

- Run this command in your command line interface:

```sh
  cd YOUR_FOLDER
  git clone https://github.com/sagieramos/hello-react-front-end
  cd hello-react-front-end
  yarn install
```

- Update the ```\.env``` with your API URL

### Usage

#### Auth Sign up
POST `http:///auth/signup`
This endpoint allows the user to create a profile
```JSON
{
  "user": {
    "username": "microverse",
    "first_name": "Joe",
    "last_name": "Stephen",
    "email": "email@example.com",
    "password": "your_password",
    "password_confirmation": "your_password",
    "city": "Nigeria"
  }
}
```
- Response
```JSON
{
  "status": {
    "code": 200,
    "message": "Signed up successfully."
  },
    "data": {
      "first_name": "Joe",
      "last_name": "Stephen",
      "city": "Nigeria",
      "username": "microversehae",
      "email": "joedja@gmail.com",
      "admin": false
    }
}

```
- status (object)
  - code (number): The status code of the response.
  - message (string): Any additional message related to the status.
- data (object):
  - first_name (string): User's first name.
  - last_name (string): User's last name.
  - city (string): User's city.
  - username (string): User's username.
  - email (string): User's email address.
  - admin (boolean): Indicates whether the user is an admin (false for regular users).
  
---

#### Auth Login
POST `http:///auth/login`
This endpoint allows the user to authenticate and login.
- Request Body
  - login (string): This can either be email or username of the user.
  - password (string): The password of the user.

- Request
``` JSON
{
  "user": {
    "login": "joe@gmail.com",
    "password": "your_password"
  }
}
```
Response
- Body

```JSON
{
  "status": {
    "code": 0,
    "message": "",
    "current_user": ""
  },
  "data": {
    "first_name": "",
    "last_name": "",
    "city": "",
    "username": "",
    "email": "",
    "admin": true
  }
}
```
- status (object)
   - code (number): The status code of the response.
   - message (string): Any additional message related to the status.
   - current_user (string): The current user's details.

- data (object)
   - first_name (string): The first name of the user.
   - last_name (string): The last name of the user.
   - city (string): The city of the user.
   - username (string): The username of the user.
   - email (string): The email of the user.

- Header
  - Authorization: Allows for stateless authentication, scalability, and can simplify the handling of authentication across multiple services

Example request authorization key
``` JS
const axios = require('axios');
let data = JSON.stringify({
  "user": {
    "login": "sagie",
    "password": "your_password"
  }
});

let config = {
  method: <YOUR_HTTP_METHOD>,
  maxBodyLength: Infinity,
  url: 'http://example.com',
  headers: { 
    'authorization': 'Bearer <VALUE>', 
    'Cookie': '_imuwahen_session=<VALUE>'
  },
  data : data
};

async function makeRequest() {
  try {
    const response = await axios.request(config);
    console.log(JSON.stringify(response.data));
  }
  catch (error) {
    console.log(error);
  }
}

makeRequest();
```

- Header (object)
  - authorization (string): Use to handle user authentication
---
#### Retrieve reservations that is associated with a user
GET ```http:///api/v1/:username/reservations```

- This endpoint makes an HTTP GET request to retrieve a list of reservations associated with a user by `:username`. The request does not contain a request body.
The response to the request has a status code of 200, indicating a successful execution. The response body contains an array of reservation data, including reservation IDs, types, attributes, and item lists associated with each reservation.

---
#### Retrieve items that is associated with a user
GET ```http:///api/v1/:username/items```

---
#### Make user an Admin
POST ```http:///api/v1/:username/make_admin```

- Make user an Admin. Admin has priviledge to manage items. 

---
#### Remove user from Admin
POST ```http:///api/v1/:username/remove_admin```

---

#### Retrieve all Items

GET ```http://localhost:4000/api/v1/p/items```

- Response Structure

The API response follows a standardized format:

```json
{
  "status": {
    "code": 200,
    "message": "Pages Items retrieved successfully.",
    "user": "sagie"
  },
  "data": [
    // Array of item objects
  ],
  "meta": {
    "total_pages": 1,
    "current_page": 1,
    "per_page": 10,
    "total_count": 6
  }
}
```
##### Data
The data array contains individual item objects, each with the following properties:

- id: Unique identifier for the item.
- name: Name of the item.
- image: Image information (null if not available).
- description: Description of the item.
- city: City information (null if not specified).
- created_at: Timestamp indicating the item's creation date.
- updated_at: Timestamp indicating the item's last update date.
- reserving_ids: Comma-separated list of reservation IDs associated with the item.
- reserving_usernames: Comma-separated list of usernames associated with the reservations.


##### Meta
The meta object provides additional metadata about the paginated results:

- total_pages: Total number of pages (e.g., 1).
- current_page: Current page number (e.g., 1).
- per_page: Number of items per page (e.g., 10).
- total_count: Total number of items across all pages (e.g., 6).

##### Client Customization
Clients can customize their requests using the following query parameters:

- per_page (Items Per Page): Specify the number of items per page.
  Example: GET ```/api/items?page=1&per_page=20```

- current_page (Current Page): Indicate which page to retrieve.
Example: GET ```/api/items?page=2&per_page=10```

Feel free to customize these parameters to suit your application's requirements.

Feel free to customize these parameters to suit your application's requirements.

---

### Request type: POST
- url: /s_admin/reservations

example:

```JSON
{
  "reservation": {
    "reserve_for_use_date": "2024-01-27",
    "reservation_items_attributes": [
      { "item_id": 1 },
      { "item_id": 2 }
    ]
  }
}

```

---

#### Request type: PATCH
- URL: /:username/reservations/:id (replace 1 with the ID of the reservation you want to edit)
- Headers:
  - Content-Type: application/json
- Body (raw JSON):
- json
Example:

``` JSON
{
  "reservation": {
    "reserve_for_use_date": "2024-02-10",
    "reservation_items_attributes": [
      { "item_id": 3 },
      { "item_id": 4 },
      { "id": 5, "_destroy": true }
    ]
  }
}
```

In this example, we're updating the reservation with ID 1, changing the reserve_for_use_date, and modifying the associated items by adding items with IDs 3 and 4 while removing the item with ID 5.

### Deployment

**This project is deployed by the author, no permission for deployment by any other client.**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

👤 **Stanley Osagie**

- GitHub: [@sagieramos](https://github.com/sagieramos)
- Twitter: [@sagieramos](https://twitter.com/sagieramos)
- LinkedIn: [LinkedIn](https://linkedin.com/in/sagieramos)
👤 **Nilab Khwajazada**

- GitHub: [@nilab-khwaja](https://github.com/nilab-khwaja)
- Twitter: [@nilab](https://x.com/NilabKhwajazada?t=hEkqy2CCNFOIfGtbmD2gLA&s=35)
- LinkedIn: [@nilab-khwajazada](https://www.linkedin.com/in/nilab-khwajazada)

👤 **Jubaer Maruf**

- GitHub: [jubaer_Maruf](https://github.com/jubaer919)
- Twitter: [@jubaer_maruf](https://twitter.com/jubaer_maruf)
- LinkedIn: [Jubaer Maruf](https://www.linkedin.com/in/jubaer-maruf/)

👤 **Lawmsangi Varte**

- GitHub: [@githubhandle](https://github.com/Lawmsangi)
- Twitter: [@twitterhandle](https://twitter.com/mamy_22_zayn)
- LinkedIn: [LinkedIn](https://www.linkedin.com/in/lawmsangi-varte-baa429244/)


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- FUTURE FEATURES -->

## 🔭 Future Features <a name="future-features"></a>

- **Add a new page**
- **Give a style**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTRIBUTING -->

## 🤝 Contributing <a name="contributing"></a>

Contributions, issues, and feature requests are welcome!

Feel free to check the [issues page](https://github.com/sagieramos/hello-react-front-end/issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- SUPPORT -->

## ⭐️ Show your support <a name="support"></a>

If you like this project, kindly drop a start ⭐️ for the [repository](https://github.com/sagieramos/hello-react-front-end);

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGEMENTS -->

## 🙏 Acknowledgments <a name="acknowledgements"></a>

I would like to express my heartfelt gratitude to **Microvere** for the invaluable learning experience they have provided.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## 📝 License <a name="license"></a>

This project is [MIT](./LICENSE) licensed.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
