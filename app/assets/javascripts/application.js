// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require moment
//= require jquery3
//= require popper
//= require bootstrap
//= require fullcalendar
//= require fullcalendar/locale-all
//= require dataTables/jquery.dataTables

$(function () {
    function eventCalendar() {
        console.log("passando em eventCalendario");
        return $('#calendar').fullCalendar({});
    };
    function clearCalendar() {
        $('#calendar').html('');
    };


    $(document).on('turbolinks:load', function () {
        eventCalendar();
    });
    $(document).on('turbolinks:before-cache', clearCalendar);

    /*
    $('#calendar').fullCalendar({
        events: '/events.json'
    });
    */

    $('#calendar').fullCalendar({
        locale: 'pt-br',
        //events: 'http://bernard.icb.usp.br/calendarfarmacoequip/events.json',
        events: '/events.json',
        titleFormat: 'MMMM YYYY ',

        dayNamesShort: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],

        header: {
            left: '',
            center: 'title',
            right: 'today prev,next'
        },

        defaultTimedEventDuration: '03:00:00',
        buttonText: {
            prev: '<<',
            next: '>>',
            prevYear: '>>>>',
            nextYear: '<<<<',
            today: 'Hoje',
            month: 'M',
            week: 'Semanal',
            day: 'D'
        },

        timeFormat: "HH:mm",

        /*eventColor: '#ef63b9',*/
        height: 500,

        eventTextColor: '#000000',
    });


    $('#calendario').fullCalendar({
        locale: 'pt-br',        
        //events: 'http://bernard.icb.usp.br/calendarfarmacoequip/resultagenda.json',
        events: '/resultagenda.json',
        titleFormat: 'MMMM YYYY ',

        dayNamesShort: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],

        header: {
            left: '',
            center: 'title',
            right: 'today prev,next'
        },

        defaultTimedEventDuration: '03:00:00',
        buttonText: {
            prev: '<<',
            next: '>>',
            prevYear: '>>>>',
            nextYear: '<<<<',
            today: 'Hoje',
            month: 'M',
            week: 'Semanal',
            day: 'D'
        },

        timeFormat: "HH:mm",

        /*eventColor: '#ef63b9',*/
        height: 500,

        eventTextColor: '#000000',
    });

});

$(document).ready(function(){
    $(".observacao #event_sala_id").change(function(){

        //$.ajax("http://bernard.icb.usp.br/calendarfarmacoequip/salas.json?sala_id=" + this.value)
        $.ajax("/salas.json?sala_id=" + this.value)
        .done(function(data){            
            $("#event_observacao").html("Informações gerais: " + data[0].observacao);
        })
        .fail(function(){
            alert("Falhou");
        });
    });
});


