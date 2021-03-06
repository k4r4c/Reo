package nl.cwi.reo.interpret.booleans;

import java.util.Map;

import nl.cwi.reo.interpret.ranges.Expression;
import nl.cwi.reo.interpret.variables.VariableName;


public final class BooleanDisjunction implements BooleanExpression {
	
	private final BooleanExpression e1;
	private final BooleanExpression e2;
	
	public BooleanDisjunction(BooleanExpression e1, BooleanExpression e2) {
		if (e1 == null || e2 == null)
			throw new NullPointerException();
		this.e1 = e1;
		this.e2 = e2;
	}
	
	public BooleanExpression evaluate(Map<VariableName, Expression> params) throws Exception {
		BooleanExpression x1 = e1.evaluate(params);
		BooleanExpression x2 = e2.evaluate(params);
		if (x1 instanceof BooleanValue && x2 instanceof BooleanValue)
			return BooleanValue.disjunction((BooleanValue)x1, (BooleanValue)x2);
		return new BooleanDisjunction(x1, x2);
	}
	
	@Override
	public String toString() {
		return "(" + e1 + "||" + e2 + ")";
	}
}