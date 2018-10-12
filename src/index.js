import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

const app = Main.embed(document.getElementById("root"));

app.ports.toJs.subscribe(function(str) {
  console.log("got from Elm:", str);
  ga("send", "pageview", `/index.html?query=${str}`);
});

registerServiceWorker();
