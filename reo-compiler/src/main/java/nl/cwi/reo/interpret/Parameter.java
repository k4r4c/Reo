package nl.cwi.reo.interpret;

public class Parameter {
	
	private String name;
	
	private ParameterType type;
	
	public Parameter(String name, ParameterType type) {
		this.name = name;
		this.type = type;
	}

	public String getName() {
		return this.name;
	}
	
	public ParameterType getType() {
		return this.type;
	}
}