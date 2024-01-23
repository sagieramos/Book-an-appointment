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
      - [Get Items](#get-items)
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
  - email (string): The email of the user.
  - password (string): The password of the user.

- Response
``` JSON
{
  "email": "joe@gmail.com",
  "password": "your_password"
}
```
---

#### Get Items
GET ```http:///api/v1/p/items```
This endpoint makes an HTTP GET request to retrieve a list of items.
- Request body
  - The request does not contain a request body.

- Response
  - Status: 200
  - Body: 
```JSON
    {
  "status": {
    "code": 0,
    "message": "",
    "user": ""
  },
  "data": [
    {
      "id": 0,
      "name": "",
      "image": null,
      "description": "",
      "city": "",
      "created_at": "",
      "updated_at": "",
      "reserving_ids": "",
      "reserving_usernames": ""
    }
  ],
  "meta": {
    "total_pages": 0,
    "current_page": 0,
    "per_page": 0,
    "total_count": 0
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

Example:
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

This endpoint retrieves a list of items with their details.



### Deployment

**This project is deployed by the author, no permission for deployment by any other client.**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- AUTHORS -->

## 👥 Authors <a name="authors"></a>

👤 **Stanley Osagie**

- GitHub: [@sagieramos](https://github.com/sagieramos)
- Twitter: [@sagieramos](https://twitter.com/sagieramos)
- LinkedIn: [LinkedIn](https://linkedin.com/in/sagieramos)

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