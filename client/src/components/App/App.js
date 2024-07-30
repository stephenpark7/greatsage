import React, { useState } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { ToastContainer } from "react-toastify";
import { Home, Register, Login, Dashboard } from "../../pages";
import { UserContext } from "../../lib";
import { User } from "../../lib";
import "react-toastify/dist/ReactToastify.css";
import "./styles.css";

const pages = [
  {
    path: "/signup",
    element: <Register />,
  },
  {
    path: "/login",
    element: <Login />,
  },
  {
    path: "/dashboard",
    element: <Dashboard />
  },
  {
    path: "/",
    element: <Home />,
  },
];

const router = createBrowserRouter(pages);

export default function App() {
  const [ isLoggedIn, setIsLoggedIn ] = useState(User.getJWT());

  return (
    <UserContext.Provider 
      value={{
        isLoggedIn,
        setIsLoggedIn,
      }}
    >
      <RouterProvider router={router} />
      <ToastContainer
        position="top-right"
        autoClose={2000}
        hideProgressBar={true}
        newestOnTop={false}
        closeOnClick
        rtl={false}
        pauseOnFocusLoss
        draggable
        pauseOnHover
        theme="light"
      />
    </UserContext.Provider>
  )
}
