const form = document.querySelector('#city-form');
const cityList = document.querySelector('#city-list');

form.addEventListener('submit', function(event) {
  event.preventDefault();
  const formData = new FormData(form);
  const searchParams = new URLSearchParams();
  
  // iterate over form data and append each key-value pair to search params
  for (const pair of formData.entries()) {
    if (pair[1] && document.querySelector(`input[name="${pair[0]}-enabled"]`).checked) {
      searchParams.append(pair[0], pair[1]);
    }
  }
  
  const query = searchParams.toString();
  
  if (query) {
    fetch(`http://localhost:8000/graphql?${query}`)
      .then(response => response.json())
      .then(data => {
        cityList.innerHTML = '';
        data.forEach(city => {
          const cityDiv = document.createElement('div');
          cityDiv.classList.add('city');
          cityDiv.innerHTML = `
            <h2>${city.name}, ${city.country}</h2>
            <p>Population: ${city.population}</p>
            <p>Area: ${city.area} km²</p>
            <p>Elevation: ${city.elevation} m</p>
            <p>Climate: ${city.climate}</p>
            <p>Crime Rate: ${city.crimeRate}</p>
            <p>Cost of Living Index: ${city.costOfLiving}</p>
            <p>Employment Rate: ${city.employmentRate}%</p>
            <p>Median Income: $${city.medianIncome}</p>
            <p>Quality of Life Index: ${city.qualityOfLife}</p>
          `;
          cityList.appendChild(cityDiv);
        });
      })
      .catch(error => {
        console.error(error);
        cityList.innerHTML = '<p>An error occurred while fetching city data. Please try again later.</p>';
      });
  } else {
    cityList.innerHTML = '<p>Please enable at least one search criteria.</p>';
  }
});

