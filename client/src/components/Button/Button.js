import { useContext } from "react";
import { useNavigate } from "react-router-dom";
import { API, UserContext } from "../../lib";
import styles from "./Button.module.css";

// TODO: use enum for type instead of string

export default function Button({ children, type, path }) {
  const { setIsLoggedIn } = useContext(UserContext);
  const navigate = useNavigate();

  function handleClick() {
    if (type === "logout") {
      handleLogout();
      return;
    }
    navigate(path);
  };

  function handleLogout() {
    API.logout();
    setIsLoggedIn(false);
  }

  return (
    <button className={styles.button} onClick={handleClick}>
      {children}
    </button>
  )
};
