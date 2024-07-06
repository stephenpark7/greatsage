import { toast } from "react-toastify";
import { User } from "./User";

const REGISTER_URL = "http://localhost:3000/api/v1/register";
const LOGIN_URL = "http://localhost:3000/api/v1/login";
const LOGOUT_URL = "http://localhost:3000/api/v1/logout";

export const API = {
  register: async (email, password) => {
    const response = await fetch(REGISTER_URL, {
      method: "POST",
      headers: {
        "Accept": "application/json", 
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, password }),
      credentials: "include",
    });
    const data = await response.json();
    if (data.error) {
      toast.error(data.error);
      return data;
    } else {
      toast.success("Account created successfully");
      return data;
    }
  },
  login: async (email, password) => {
    const response = await fetch(LOGIN_URL, {
      method: "POST",
      headers: {
        "Accept": "application/json", 
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ email, password }), 
      credentials: "include",
    });
    const data = await response.json();
    if (data.error) {
      toast.error(data.error);
      return data;
    } 
    toast.success("Logged in successfully");
    User.setJWT();
    return data;
  },
  logout: async () => {
    // TODO: send a request to the server to invalidate the JWT
    const response = await fetch(LOGOUT_URL, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      credentials: "include",
    });
    const data = await response.json();
    if (data.error) {
      toast.error(data.error);
      return data;
    }
    toast.success("You have successfully logged out");
    User.removeJWT();
    return data;
  },
  // refreshJWT: async () => {
  //   const jwt = User.getJWT();

  //   if (!jwt.access_token || jwt.access_token.exp > new Date().getTime()) {
  //     const response = await fetch("http://localhost:3000/api/v1/refresh_token", {
  //       method: "GET",
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/json",
  //         "Authorization": `Bearer ${jwt.refresh_token.token}`,
  //       },
  //       credentials: "include",
  //     });

  //     const data = await response.json();
      
  //     if (data.error) {
  //       toast.error(data.error);
  //       User.removeJWT();
  //       return data;
  //     }

  //     User.setJWT(data);
  //   }

  //   return jwt;
  // },
  getTodoList: async () => {
    // const jwt = await API.refreshJWT();
    
    const response = await fetch("http://localhost:3000/api/v1/self", {
      method: "GET",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // "Authorization": `Bearer ${jwt.access_token.token}`,
      },
      credentials: "include",
    });

    const data = await response.json();

    if (data.error) {
      toast.error(data.error);
      if (response.status === 401) {
        // User.removeJWT();
        return { error: data.error };
      }
    }

    return data;
  }
};
