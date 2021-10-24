window.addEventListener('load', () => {
    let porcentaje = 50
    this.addEventListener('message', e => {
        switch (e.data.action) {
            case 'openMenu':
                porcentaje = e.data.zonePercentage
                doc.getElementById('contrato').style.display = 'flex';
            break;
        }
    })

    doc.getElementById('cantidad').addEventListener('input', e => {
        if (e.target.value) {
            doc.getElementById('agreement').style.display = 'flex';
        } else {
            doc.getElementById('agreement').style.display = 'none';

        }
        document.querySelector('#agreement').textContent = (e.target.value / 100) * porcentaje + " Will be retired from the total" ;
     });

    // doc.getElementById('confirmar').addEventListener('click', e => {
    //     const cantiInput = document.querySelector('#cantidad').textContent;
    //     if (cantiInput == undefined) {
    //         return
    //     }
    //  });

    doc.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            doc.getElementById('contrato').style.display = 'none';
            fetchNUI('getMoneyData', cantiInput);
        }
    });

})