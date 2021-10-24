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
        let val = e.target.value;
        if (val) {
            agree.style.display = 'flex';
        } else {
            agree.style.display = 'none';
        }
        if (val < 0) {
            agree.textContent = 'Cannot have a negative input!'
        } else {
            agree.textContent = `${porcentaje}% will be taken as taxes!`;
        }
     });

    doc.getElementById('confirm').addEventListener('click', e => {
        const cantiInput = count.value;
        const cantiPorcentaje = Math.ceil((cantiInput / 100) * porcentaje);
        if (!cantiInput) {
            return fetchNUI('getMoneyData', {notify: 'NoData'});
        } else {
            if (cantiInput <= 0) {
                return fetchNUI('getMoneyData', {notify: 'NegativeValue'});
            }
            fetchNUI('getMoneyData', {cantiInput: cantiInput, cantiPorcentaje: cantiPorcentaje, porcentaje: porcentaje});
            cont.style.display = 'none';
            porcentaje = undefined;
        }
     });

    doc.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            cont.style.display = 'none';
            fetchNUI('getMoneyData', false);
        }
    });

})

