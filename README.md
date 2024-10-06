# README
## Table of Contents  
1. [Setup](#setup)<br>
2. [Running tests](#running-tests)<br>
3. [Answers](#answers)<br>
4. [Sample Output](#sample-output)<br>
5. [Changelog](#changelog)<br>

<img width="948" alt="Screen Shot 2024-10-05 at 2 13 23 PM" src="https://github.com/user-attachments/assets/2e3bf2e7-046e-4a9d-bcd7-038640756614">

## Setup
The application was developed in Rails 7.0.8 against ruby version 3.3.0
* Navigate to the projects root directory ```cd investor-allocation```
* Install ruby 3.3.0, you can use a ruby version manager such as rbenv or rvm to do so.
  * rbenv

    ```rbenv install 3.3.0```

    ```rbenv local 3.3.0```
  * rvm

    ```rvm install 3.3.0```

    ```rvm use 3.3.0```
* Run command to install gems ```bundle install```
* Start the server by running ```rails s```
* Visit http://localhost:3000 in your browser

## Running tests
``` rails test test/ ```

## Answers

### Discovering a bug
1. More than one issue may have caused the problem. Prioritization is important especially when time-sensitive issues arise and resources are limited. I would prioritize the issue that occurred 2 weeks ago. The deal that took place 2 years ago was most likely completed from an AML/KYC, execution, legal, and fund transfer perspective. So there may not be much that can be done in terms of reallocating funds. However, transparency and communication are very important to ensure customers trust the product and company (refer to point 6 for how to communicate)
2. For the deal that occurred 2 weeks ago, there may be more that can be done beyond communication. The resolution starts by communicating to the customer of the issue and also inquiring where they are in the deal lifecycle to see if anything can be done to reallocate funds more appropriately.
3. I would start by investigating both issue(s) (prioritizing the recent deal) by looking at application logs, business logic in code, and consult with subject matter experts if needed.
4. Once the issue(s) have been identified a good solution(s) to the problem(s) should be decided upon and implemented. Implementation is not limited to just a fix, manual and automated test coverage should be added to ensure the same problem does not occur again in the future. 
5. The fix should be tested thoroughly by the quality assurance engineers, business analysts, and any other stakeholders involved.
6. As part of the communication in both scenarios it is important to be honest and transparent, accept responsibility for the issue, and explain what safeguards in terms of technology or process have or will be implemented to ensure that such issues do not occur again in the future.
7. A post-mortem meeting should be held internally to share what caused the issue(s) and how to be better prepared in the future.

### Squeezed down
I would start by acknowledging the customers frustration. The customer may be unaware of the business logic behind the allocations, so I would proceed to explain to them how things work under the hood. I would explain to them that to ensure fairness on the platform we use the historical average investment amount as the basis for proration. I would also communicate to them that we will take their feedback into account in an effort to improve customer experience in the future

1. Instead of relying solely on historical averages, we could introduce a hybrid proration model that takes into account both the historical averages and the real-time demand (i.e., requested amounts). This would ensure that investors’ actual preferences in a specific deal are factored into the proration alongside their typical investment behavior. The proration formula could dynamically weight these two factors 
2. Implement a demand-based dynamic proration system, where if the deal is oversubscribed (i.e., more requested amounts than allocation), we give heavier weight to real-time investor demand. Conversely, if the deal is undersubscribed, we could rely more on historical averages. This would minimize instances where investors receive too much allocation simply because of high historical averages.
3. We could factor in commitment levels (i.e., how consistently an investor participates in deals) to prioritize investors who have shown higher deal engagement. Those with a higher engagement history might get a slight preference in proration over those with sporadic participation. This rewards long-term investors and encourages participation.

## Sample output
The following inputs were first assigned to an input variable via the rails console and ```AllocationProration#allocate_investments(input)``` was called

#### Complex Input 1

```rails console ```
```
input =
{
  "allocation_amount": 100,
  "investor_amounts": [
    {
      "name": "Investor A",
      "requested_amount": 100,
      "average_amount": 95
    },
    {
      "name": "Investor B",
      "requested_amount": 2,
      "average_amount": 1
    },
    {
      "name": "Investor C",
      "requested_amount": 1,
      "average_amount": 4
    }
  ]
}
```

```AllocationProration.allocate_investments(input)```

Output

```{"Investor A"=>97.97, "Investor B"=>1.03, "Investor C"=>1}```


#### Complex Input 2

```rails console ```
```
input =
{
  "allocation_amount": 100,
  "investor_amounts": [
    {
      "name": "Investor A",
      "requested_amount": 100,
      "average_amount": 95
    },
    {
      "name": "Investor B",
      "requested_amount": 1,
      "average_amount": 1
    },
    {
      "name": "Investor C",
      "requested_amount": 1,
      "average_amount": 4
    }
  ]
}
```

```AllocationProration.allocate_investments(input)```

Output

```{"Investor A"=>98.0, "Investor B"=>1.0, "Investor C"=>1}```


#### Simple Input 1

```rails console ```
```
input =
{
  "allocation_amount": 100,
  "investor_amounts": [
    {
      "name": "Investor A",
      "requested_amount": 100,
      "average_amount": 100
    },
    {
      "name": "Investor B",
      "requested_amount": 25,
      "average_amount": 25
    }
  ]
}
```

```AllocationProration.allocate_investments(input)```

Output

```{"Investor A"=>80.0, "Investor B"=>20.0}```


#### Simple Input 2

```rails console ```
```
input =
{
  "allocation_amount": 200,
  "investor_amounts": [
    {
      "name": "Investor A",
      "requested_amount": 100,
      "average_amount": 100
    },
    {
      "name": "Investor B",
      "requested_amount": 25,
      "average_amount": 25
    }
  ]
}
```

```AllocationProration.allocate_investments(input)```

Output

```{"Investor A"=>100, "Investor B"=>25}```

## Changelog
* ```app/controllers/home_controller.rb```
* ```lib/allocation_proration.rb```
* ```app/views/home/new.html.erb```
* ```config/routes.rb```
* ```config/locales/en.yml```
* ```test/controllers/home_controller_test.rb```
* ```test/lib/allocation_proration_test.rb```
