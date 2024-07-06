import Cookies from "js-cookie";

const ACCESS_TOKEN_EXPIRY = 15 * 60 * 1000;
const DOMAIN = "localhost";

export const User = {
  getJWT: () => {
    const data = Cookies.get("isLoggedIn");
    return data === "true";
  },
  setJWT: () => {
    return Cookies.set("isLoggedIn", true, { expires: new Date().getTime() + ACCESS_TOKEN_EXPIRY });
  },
  removeJWT: () => {
    return Cookies.remove("isLoggedIn", { path: "", domain: DOMAIN });
  },
};
