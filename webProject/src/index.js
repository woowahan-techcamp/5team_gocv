import Dummy from "./dummy.js"
import "./dummy.css"

const dummy = new Dummy("testss");
const element = document.querySelector('#dummy');
element.innerHTML = dummy.getValue();

function Test(){
    const text = "dummy";
    return text;
}

