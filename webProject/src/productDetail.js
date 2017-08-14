var ctx = document.getElementById('ratingChart').getContext('2d');
var ctx1 = document.getElementById('priceChart').getContext('2d');
var ctx2 = document.getElementById('flavorChart').getContext('2d');
var ctx3 = document.getElementById('quantityChart').getContext('2d');


var chart = new Chart(ctx, {
    type: 'line',

    data: {
        labels: ["1🌟", "2🌟", "3🌟", "4🌟", "5🌟"],
        datasets: [{
            label:"",
            backgroundColor: '#ffc225',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#eeb225",
            data: [0, 10, 5, 2, 20],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
            xAxes: [{
                gridLines: {
                    display: false
                }
            }],
            yAxes: [{
                gridLines: {
                    display: false
                }
            }]
        }
    }
});


var chart = new Chart(ctx1, {
    type: 'bar',

    data: {
        labels: ["비쌈", "", "적당", "", "저렴"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [0, 10, 13, 2, 0],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
            xAxes: [{
                gridLines: {
                    display: false
                }
            }],
            yAxes: [{
                gridLines: {
                    display: false
                }
            }]
        }
    }
});
var chart = new Chart(ctx2, {
    type: 'bar',

    data: {
        labels: ["노맛", "", "적당", "", "존맛"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [9, 8, 0, 3, 0],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
            xAxes: [{
                gridLines: {
                    display: false
                }
            }],
            yAxes: [{
                gridLines: {
                    display: false
                }
            }]
        }
    }
});
var chart = new Chart(ctx3, {
    type: 'bar',

    data: {
        labels: ["창렬", "", "적당", "", "헤자"],
        datasets: [{
            label:"",
            backgroundColor: '#ee5563',
            borderColor: 'white',
            borderSkipped:"left",
            hoverBackgroundColor:"#9c3740",
            data: [0, 2, 5, 8, 10],
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        scales:{
            xAxes: [{
                gridLines: {
                    display: false
                }
            }],
            yAxes: [{
                gridLines: {
                    display: false
                }
            }]
        }
    }
});