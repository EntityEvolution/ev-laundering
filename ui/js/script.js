window.addEventListener('load', () => {
    const cont = doc.getElementById('contrato');
    const agree = doc.getElementById('agreement');
    const count = doc.getElementById('cantidad');

    let porcentaje = undefined;
    this.addEventListener('message', e => {
        switch (e.data.action) {
            case 'openMenu':
                porcentaje = e.data.zonePercentage;
                cont.style.display = 'flex';
            break;
        }
    })

    count.addEventListener('input', e => {
        if (e.target.value) {
            agree.style.display = 'flex';
        } else {
            agree.style.display = 'none';
        }
        agree.textContent = `$${Math.ceil((e.target.value / 100) * porcentaje)} will be removed from your black money`;
     });

    doc.getElementById('confirm').addEventListener('click', e => {
        const cantiInput = count.value;
        const cantiPorcentaje = Math.ceil((cantiInput / 100) * porcentaje);
        if (!cantiInput) {
            return fetchNUI('getMoneyData', false);
        } else {
            fetchNUI('getMoneyData', {cantiInput: cantiInput, cantiPorcentaje: cantiPorcentaje, porcentaje: porcentaje});
            cont.style.display = 'none';
            porcentaje = undefined;
        }
     });

    doc.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            cont.style.display = 'none';
            fetchNUI('getMoneyData', {close: true});
        }
    });

})

