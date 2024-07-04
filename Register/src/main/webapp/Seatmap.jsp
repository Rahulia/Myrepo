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

                const zone = document.createElement('div');
                zone.classList.add('zone');
                zone.dataset.zone = zoneCounter;

                const zoneNameInput = document.createElement('input');
                zoneNameInput.type = 'text';
                zoneNameInput.placeholder = 'Zone Name';
                zoneNameInput.name = 'zoneName';
                zoneNameInput.value = 'zone' + zoneCounter; // Ensure unique value for zone name
                zone.appendChild(zoneNameInput);

                const addSectionBtn = document.createElement('button');
                addSectionBtn.type = 'button';
                addSectionBtn.classList.add('addSectionBtn');
                addSectionBtn.dataset.zone = zoneCounter;
                addSectionBtn.textContent = '+Section';
                zone.appendChild(addSectionBtn);

                const removeZoneBtn = document.createElement('button');
                removeZoneBtn.type = 'button';
                removeZoneBtn.classList.add('removeZoneBtn');
                removeZoneBtn.textContent = '-';
                zone.appendChild(removeZoneBtn);

                const sections = document.createElement('div');
                sections.classList.add('sections');
                zone.appendChild(sections);

                $("#seatMapContainer").append(zone);
            });

            $(document).on("click", ".addSectionBtn", function() {
                let zoneId = $(this).data("zone");
                sectionCounter[zoneId]++;

                const section = document.createElement('div');
                section.classList.add('section');
                section.dataset.section = sectionCounter[zoneId];

                const sectionNameInput = document.createElement('input');
                sectionNameInput.type = 'text';
                sectionNameInput.placeholder = 'Section Name';
                sectionNameInput.name = 'zone' + zoneId + '_sectionName';
                section.appendChild(sectionNameInput);

                const rowNoInput = document.createElement('input');
                rowNoInput.type = 'number';
                rowNoInput.placeholder = 'Row No';
                rowNoInput.name = 'zone' + zoneId + '_section' + sectionCounter[zoneId] + '_rowNo';
                section.appendChild(rowNoInput);

                const seatNumberInput = document.createElement('input');
                seatNumberInput.type = 'number';
                seatNumberInput.placeholder = 'Number of Seats';
                seatNumberInput.name = 'zone' + zoneId + '_section' + sectionCounter[zoneId] + '_seatNumber';
                section.appendChild(seatNumberInput);

                const zonePriceInput = document.createElement('input');
                zonePriceInput.type = 'text';
                zonePriceInput.placeholder = 'Price';
                zonePriceInput.name = 'zone' + zoneId + '_section' + sectionCounter[zoneId] + '_zonePrice';
                section.appendChild(zonePriceInput);

                const statusSelect = document.createElement('select');
                statusSelect.name = 'zone' + zoneId + '_section' + sectionCounter[zoneId] + '_status';
                const availableOption = document.createElement('option');
                availableOption.value = 'Available';
                availableOption.text = 'Available';
                statusSelect.appendChild(availableOption);
                const bookedOption = document.createElement('option');
                bookedOption.value = 'Booked';
                bookedOption.text = 'Booked';
                statusSelect.appendChild(bookedOption);
                section.appendChild(statusSelect);

                const removeSectionBtn = document.createElement('button');
                removeSectionBtn.type = 'button';
                removeSectionBtn.classList.add('removeSectionBtn');
                removeSectionBtn.textContent = '-';
                section.appendChild(removeSectionBtn);

                $(this).siblings(".sections").append(section);
              });

              $(document).on("click", ".removeZoneBtn", function() {
                $(this).parent().remove();
              });

              $(document).on("click", ".removeSectionBtn", function() {
                $(this).parent().remove();
              });

              // Add form submission handler with validation
              $("#seatMapContainer form").submit(function(event) {
                // Check if any required fields are empty
                let hasEmptyField = false;
                $("#seatMapContainer input[type='text'], #seatMapContainer input[type='number']").each(function() {
                  if ($(this).val() === "") {
                    hasEmptyField = true;
                    $(this).addClass("error"); // Add error class for styling (optional)
                    event.preventDefault(); // Prevent form submission if empty field found
                  } else {
                    $(this).removeClass("error"); // Remove error class if field is filled (optional)
                  }
                });

                if (hasEmptyField) {
                  alert("Please fill in all required fields (Zone Name, Row No, Number of Seats, Price).");
                  return false; // Prevent default form submission behavior
                }
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
            hallId = "1"; // Handle null case if needed
        }
        %>
        <form action="UpdateServlet" method="post">
            <input type="hidden" name="hallId" value="<%= hallId %>">
            <div id="seatMapContainer"></div>
            <button type="button" id="addZoneBtn">+Zone</button>
            <button type="submit">Create</button>
        </form>
    </div>
</body>
</html>





















