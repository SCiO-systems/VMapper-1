
<!DOCTYPE html>
<html>
    <head>
        <#include "../header.ftl">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.js"></script>
        <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/vis/4.21.0/vis.min.css" />
    </head>

    <body>

        <#include "../nav.ftl">

        <div class="container">
            <div class="row">
            </div>
            <div id="visualization"></div>
        </div>

        <#include "../footer.ftl">
        
        <script type="text/javascript">
            // DOM element where the Timeline will be attached
            var container = document.getElementById('visualization');

            // Create a DataSet (allows two way data-binding)
            var items = new vis.DataSet([
              {id: 1, content: 'item 1', start: '2013-04-20'},
              {id: 2, content: 'item 2', start: '2013-04-14'},
              {id: 3, content: 'item 3', start: '2013-04-18'},
              {id: 4, content: 'item 4', start: '2013-04-16', end: '2013-04-19'},
              {id: 5, content: 'item 5', start: '2013-04-25'},
              {id: 6, content: 'item 6', start: '2013-04-27'}
            ]);

            // Configuration for the Timeline
            var options = {};

            // Create a Timeline
            var timeline = new vis.Timeline(container, items, options);
        </script>
    </body>
</html>
