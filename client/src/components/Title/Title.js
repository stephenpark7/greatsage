import { Link } from "react-router-dom";
import styles from "./Title.module.css";

const app_title = "GreatSage";

export default function Title() {
  return (
    <h1 className={styles.title}>
      <Link className={styles.link} to="/">
        {app_title}
      </Link>
    </h1>
  );
}
