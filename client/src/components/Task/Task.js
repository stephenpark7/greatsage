import { FaCheck } from "react-icons/fa";
import { MdClear } from "react-icons/md";
import styles from "./Task.module.css";

export default function Task ({ id, title, deleteTaskHandler }) {

  const completeTask = () => {
    
  };

  const deleteTask = () => {
    deleteTaskHandler(id);
  };

  return (
      <>
        <li className={styles.container}>
          <div className={styles.title}>{title}</div>
          <div className={styles.buttons}>
            <div className={styles.button} onClick={completeTask}>
              <FaCheck />
            </div>
            <div className={styles.button} onClick={deleteTask}>
              <MdClear />
            </div>
          </div>
        </li>
      </>
  );
}
