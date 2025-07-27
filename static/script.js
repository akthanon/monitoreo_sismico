// static/script.js
let x = [], ax = [], ay = [], az = [];

Plotly.newPlot('graph', [{
    y: ax, name: 'Ax', mode: 'lines'
  }, {
    y: ay, name: 'Ay', mode: 'lines'
  }, {
    y: az, name: 'Az', mode: 'lines'
}], {
    title: 'Aceleración MPU6050',
    xaxis: { title: 'Tiempo (últimos 10s)' },
    yaxis: { title: 'g' }
});

function updateGraph() {
  fetch('/data')
    .then(res => res.json())
    .then(data => {
      const time = new Date(data.timestamp).toLocaleTimeString();
      x.push(time);
      ax.push(data.Ax);
      ay.push(data.Ay);
      az.push(data.Az);
      if (x.length > 100) {  // mantiene los últimos 100 puntos (~10s)
        x.shift(); ax.shift(); ay.shift(); az.shift();
      }

      Plotly.update('graph', {
        x: [x, x, x],
        y: [ax, ay, az]
      });
    });
}

setInterval(updateGraph, 100); // actualiza cada 100ms
