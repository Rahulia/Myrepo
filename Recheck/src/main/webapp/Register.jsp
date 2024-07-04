<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Seat Map</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        let zoneCounter = 0;
        let sectionCounter = {};
        

        $(document).ready(function() {

            $("#addZoneBtn").click(function() {
                zoneCounter++;
                sectionCounter[zoneCounter] = 0;

                // Create zone element dynamically
                const zone = document.createElement('div');
                zone.classList.add('zone');
                zone.dataset.zone = zoneCounter;

                // Zone name input
                const zoneNameInput = document.createElement('input');
                zoneNameInput.type = 'text';
                zoneNameInput.placeholder = 'Zone Name';
                zoneNameInput.name = `zoneName${zoneCounter}`;
                zone.appendChild(zoneNameInput);

                // Add section button
                const addSectionBtn = document.createElement('button');
                addSectionBtn.type = 'button';
                addSectionBtn.classList.add('addSectionBtn');
                addSectionBtn.dataset.zone = zoneCounter;
                addSectionBtn.textContent = '+Section';
                zone.appendChild(addSectionBtn);

                // Remove zone button
                const removeZoneBtn = document.createElement('button');
                removeZoneBtn.type = 'button';
                removeZoneBtn.classList.add('removeZoneBtn');
                removeZoneBtn.textContent = '-';
                zone.appendChild(removeZoneBtn);

                // Section container
                const sections = document.createElement('div');
                sections.classList.add('sections');
                zone.appendChild(sections);

                // Append zone to container
                $("#seatMapContainer").append(zone);
            });

            $(document).on("click", ".addSectionBtn", function() {
                let zoneId = $(this).data("zone");
                sectionCounter[zoneId]++;

                // Create section element dynamically
                const section = document.createElement('div');
                section.classList.add('section');
                section.dataset.section = sectionCounter[zoneId];

                // Section name input
                const sectionNameInput = document.createElement('input');
                sectionNameInput.type = 'text';
                sectionNameInput.placeholder = 'Section Name';
                sectionNameInput.name = `sectionName${zoneId}_${sectionCounter[zoneId]}`;
                section.appendChild(sectionNameInput);

                // Row number input
                const rowNoInput = document.createElement('input');
                rowNoInput.type = 'number';
                rowNoInput.placeholder = 'Row No';
                rowNoInput.name = `rowNo${zoneId}_${sectionCounter[zoneId]}`;
                section.appendChild(rowNoInput);

                // Number of seats input
                const seatNumberInput = document.createElement('input');
                seatNumberInput.type = 'number';
                seatNumberInput.placeholder = 'Number of Seats';
                seatNumberInput.name = `seatNumber${zoneId}_${sectionCounter[zoneId]}`;
                section.appendChild(seatNumberInput);

                // Price and number of seats input (separated)
                const zonePriceInput = document.createElement('input');
                zonePriceInput.type = 'text';
                zonePriceInput.placeholder = 'Price, Number of Seats';
                zonePriceInput.name = `zonePrice${zoneId}_${sectionCounter[zoneId]}`;
                section.appendChild(zonePriceInput);

                // Status select
                const statusSelect = document.createElement('select');
                statusSelect.name = `status${zoneId}_${sectionCounter[zoneId]}`;
                const availableOption = document.createElement('option');
                availableOption.value = 'Available';
                availableOption.text = 'Available';
                statusSelect.appendChild(availableOption);
                const bookedOption = document.createElement('option');
                bookedOption.value = 'Booked';
                bookedOption.text = 'Booked';
                statusSelect.appendChild(bookedOption);
                section.appendChild(statusSelect);

                // Remove section button
                const removeSectionBtn = document.createElement('button');
                removeSectionBtn.type = 'button';
                removeSectionBtn.classList.add('removeSectionBtn');
                removeSectionBtn.textContent = '-';
                section.appendChild(removeSectionBtn);

                // Append section to zone
                $(this).siblings(".sections").append(section);
            });

            $(document).on("click", ".removeZoneBtn", function() {
                $(this).parent().remove();
            });

            $(document).on("click", ".removeSectionBtn", function() {
                $(this).parent().remove();
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <h2>Create Seat Map</h2>
        <% 
        String hallId = request.getParameter("h"); 
        if (hallId == null) {
            hallId = ""; // Handle null case if needed
        }
        %>
        <form action="LogServlet" method="post">
    <input type="hidden" name="hallId" value="<%= hallId %>">
    <div id="seatMapContainer"></div>
    <button type="button" id="addZoneBtn">+Zone</button>
    <button type="submit">Create</button>
</form>
    </div>
</body>
</html>