class AllocationProration
  def self.allocate_investments(input)
    allocation_amount = input[:allocation_amount]
    investors = input[:investor_amounts]

    total_historical_average = investors.sum { |investor| investor[:average_amount] }

    allocation_breakdown = {}

    # Initial allocation based on historical averages
    investors.each do |investor|
      allocated_amount = calculate_prorated_amount(investor[:average_amount], total_historical_average, allocation_amount)

      # Ensure the allocated amount does not exceed the requested amount
      allocated_amount = [allocated_amount, investor[:requested_amount]].min
      allocation_breakdown[investor[:name]] = allocated_amount
    end

    # Calculate the total allocated amount
    total_allocated = allocation_breakdown.values.sum

    # If there is any unused allocation, redistribute it
    if total_allocated < allocation_amount
      unused_allocation = allocation_amount - total_allocated

      # Create a list of investors who can still receive more
      eligible_investors = investors.select do |investor|
        allocation_breakdown[investor[:name]] < investor[:requested_amount]
      end

      # Redistribute the unused allocation based on historical averages
      eligible_total_historical_average = eligible_investors.sum { |investor| investor[:average_amount] }

      eligible_investors.each do |investor|
        if eligible_total_historical_average > 0
          additional_allocation = calculate_prorated_amount(investor[:average_amount], eligible_total_historical_average, unused_allocation)

          # Ensure the additional allocation does not exceed the remaining requested amount
          additional_allocation = [
            additional_allocation,
            investor[:requested_amount] - allocation_breakdown[investor[:name]]
          ].min

          allocation_breakdown[investor[:name]] += additional_allocation
        end
      end
    end

    allocation_breakdown
  end

  private

  def self.calculate_prorated_amount(historical_average, total_historical_average, allocation_amount)
    (allocation_amount * (historical_average.to_f / total_historical_average)).round(2)
  end
end
