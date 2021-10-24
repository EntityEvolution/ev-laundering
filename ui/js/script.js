window.addEventListener('load', () => {
    this.addEventListener('message', e => {
        switch (e.data.action) {
            case "openMenu":

                doc.getElementById("contrato").style.display = "flex";

            break
        }
    })
    doc.addEventListener("onkeyup", e => {
        if (e.key == "Escape") {
            doc.getElementById("contrato").style.display = "none";
            fetchNUI("getMoneyData")
        }
    });

})