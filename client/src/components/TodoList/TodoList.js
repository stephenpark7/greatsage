import { useEffect, useState } from "react";
import { API } from "../../lib";
import Task from "../Task/Task";
import styles from "./TodoList.module.css";

export default function TodoList() {
   const heading = "Todo List";

   const [ tasks, setTasks ] = useState(null);
   const [ fetchFlag, setFetchFlag ] = useState(false);

   useEffect(() => {
      async function fetchData() {
         const todos = await API.getTodoList();
         if (todos.error) {
            setTasks([]);
            setFetchFlag(true);
            return;
         }
         todos.forEach((todo, idx) => {
            todo.id = idx;
         });
         setTasks(todos);
         setFetchFlag(true);
      }
      if (!fetchFlag) {
         fetchData();
      }
   }, [ fetchFlag ]);

   const deleteTask = (id) => {
      let newTasks = tasks.slice();
      for (let i = 0; i < newTasks.length; i++) {
         if (newTasks[i].id === id) {
            newTasks.splice(i, 1);
            break;
         }
      }
      // TODO: set up animation
      // send delete request to API
      // or debounce the delete request
      // so that multiple deletions can be batched
      // and sent in one request
      setTasks(newTasks);
   };

   return (
      <div className={styles.container}>
         <h1 className={styles.heading}>{heading}</h1>
         <ul className={styles.list}>
            {tasks && tasks.map((task) => (
               <Task
                  id={task.id}
                  title={task.title}
                  key={task.id}
                  deleteTaskHandler={deleteTask}
               />
            ))}
         </ul>
      </div>
   );
}
