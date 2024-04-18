# calculatorSpec.coffee

describe 'Calculator', -> 
  calculator = null

  beforeEach -> 
    calculator = new Calculator()
	
  it 'can add two positive numbers', ->
    result = calculator.add 2, 3
    expect(result).toBe 5
	
  it 'can handle negative number addition', ->
    result = calculator.add -10, 5
    expect(result).toBe -5
	
  it 'can subtract two positive numbers', ->
    result = calculator.subtract 10, 6
    expect(result).toBe 4
	
  it 'can handle negative number subtraction', ->
    result = calculator.subtract 4, -6
    expect(result).toBe 10

