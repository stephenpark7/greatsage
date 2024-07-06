import { createContext } from "react";
import { API } from "./API";
import { User } from "./User";

const UserContext = createContext({
  isLoggedIn: false,
  setIsLoggedIn: () => {},
});

export {
  API,
  User,
  UserContext,
};
