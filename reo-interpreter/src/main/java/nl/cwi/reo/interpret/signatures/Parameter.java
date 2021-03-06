package nl.cwi.reo.interpret.signatures;

import java.util.Map;

import nl.cwi.reo.interpret.Evaluable;
import nl.cwi.reo.interpret.ranges.Range;
import nl.cwi.reo.interpret.ranges.Expression;
import nl.cwi.reo.interpret.variables.Variable;
import nl.cwi.reo.interpret.variables.VariableName;

/**
 * An immutable parameter implementation.
 */
public final class Parameter implements Evaluable<Parameter> {
	
	private final Variable var;
	
	private final ParameterType type;
	
	public Parameter(Variable var, ParameterType type) {
		if (var == null || type == null)
			throw new NullPointerException();
		this.var = var;
		this.type = type;
	}

	public Variable getVariable() {
		return this.var;
	}
	
	public ParameterType getType() {
		return this.type;
	}

	@Override
	public Parameter evaluate(Map<VariableName, Expression> params) throws Exception {
		Range e = var.evaluate(params);
		if (!(e instanceof Variable))
			e = var;
		return new Parameter((Variable)e, type);
	}
	
	@Override
	public String toString() {
		return var + (type instanceof TypeTag ? ":" : "") + type;
	}
}
