import { useContext } from "react";
import { UserContext } from "../../lib";
import Title from "../../components/Title/Title";
import Button from "../../components/Button/Button";
import styles from "../../components/Button/Button.module.css";

export default function Home() {
  const { isLoggedIn } = useContext(UserContext);

  function renderButtons() {
    if (isLoggedIn) {
      return (
        <div className={styles.buttons}>
          <Button path="/dashboard">Dashboard</Button>
          <Button type="logout">Log out</Button>
        </div>
      );
    } else {
      return (
        <div className={styles.buttons}>
          <Button path="/signup">Sign up</Button>
          <Button path="/login">Log in</Button>
        </div>
      );
    }
  }

  return (
    <div className="container">
      <Title />
      {renderButtons()}
    </div>
  );
}
