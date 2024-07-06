import { useContext } from "react";
import { useNavigate } from "react-router-dom";
import { toast } from "react-toastify";
import { API, UserContext } from "../../lib";
import styles from "./Form.module.css";

export default function Form({ type }) {
  const { setIsLoggedIn } = useContext(UserContext);
  const navigate = useNavigate();

  const onSubmitFunc = type === "register" ? 
    handleRegister : 
    handleLogin;

  const buttonText = type === "register" ?
    "Sign up" :
    "Login";

  async function handleRegister(event) {
    event.preventDefault();

    const email = document.querySelector("input[name=email]").value;
    const password = document.querySelector("input[name=password]").value;
    const confirmPassword = document.querySelector("input[name=confirm-password]").value;

    if (email === "" || password === "" || confirmPassword === "") {
      toast.error("Please fill in all fields");
      return;
    }
    
    if (password !== confirmPassword) {
      toast.error("Passwords do not match");
      return;
    }

    const userData = await API.register(email, password);
    if (userData.error) {
      return;
    }

    navigate("/");
  }

  async function handleLogin(event) {
    event.preventDefault();

    const email = document.querySelector("input[name=email]").value;
    const password = document.querySelector("input[name=password]").value;

    if (email === "" || password === "") {
      toast.error("Please fill in all fields");
      return;
    }

    const userData = await API.login(email, password);
    if (userData.error) {
      return;
    }

    setIsLoggedIn(true);
    navigate("/");
  }

  return (
    <form 
      className={styles.form}
      method="POST" 
      onSubmit={onSubmitFunc}
    >
      <input 
        className={styles.input} 
        type="email" name="email" 
        placeholder="Email" 
        autoComplete="on" 
      />
      <input 
        type="password" 
        name="password" 
        placeholder="Password" 
        autoComplete="on" 
      />
      {
        type === "register" && 
        <input 
          type="password" 
          name="confirm-password" 
          placeholder="Confirm password" 
          autoComplete="on" 
        />
      }
      <button type="submit">
        {buttonText}
      </button>
    </form>
  )
}
