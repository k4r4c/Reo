package nl.cwi.reo.interpret.programs;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import nl.cwi.reo.interpret.booleans.BooleanExpression;
import nl.cwi.reo.interpret.booleans.BooleanValue;
import nl.cwi.reo.interpret.ranges.Expression;
import nl.cwi.reo.interpret.variables.VariableName;
import nl.cwi.reo.semantics.Semantics;

/**
 * A parameterized for loop of a set {link java.util.Set}&lt;{link nl.cwi.reo.parse.Component}&gt; of parameterized components.
 */
public class ProgramIfThenElse<T extends Semantics<T>> implements ProgramExpression<T> {
	
	/**
	 * Conditions for each branch. If there are more conditions than branches, 
	 * then the additional conditions are ignored.
	 */
	public List<BooleanExpression> conditions;
	
	/**
	 * Branches of subprograms.
	 */
	public List<ProgramExpression<T>> branches;

	/**
	 * Constructs a parameterized if statement. 
	 * @param conditions		guards of each branch
	 * @param branches			subcomponent and definitions
	 */
	public ProgramIfThenElse(List<BooleanExpression> conditions, List<ProgramExpression<T>> branches) {
		if (conditions == null || branches == null)
			throw new NullPointerException();
		this.conditions = conditions;
		this.branches = branches;
	}
	
	/**
	 * Gets a {link nl.cwi.reo.ProgramInstance} for a particular parameter assignment.
	 * @param parameters		parameter assignment
	 * @return Program instance {link nl.cwi.reo.ProgramInstance} for this parameterized component
	 * @throws Exception if the provided parameters do not match the signature of this program.
	 */
	public ProgramExpression<T> evaluate(Map<VariableName, Expression> params) throws Exception {
		boolean canEvaluate = true;
		List<BooleanExpression> conditions_p = new ArrayList<BooleanExpression>();
		List<ProgramExpression<T>> branches_p = new ArrayList<ProgramExpression<T>>();		
		Iterator<BooleanExpression> condition = conditions.iterator();
		Iterator<ProgramExpression<T>> branch =  branches.iterator();
		while (condition.hasNext() && branch.hasNext()) {
			BooleanExpression e = condition.next().evaluate(params);
			ProgramExpression<T> b = branch.next().evaluate(params);
			conditions_p.add(e);
			branches_p.add(b);
			if (canEvaluate && e instanceof BooleanValue) {
				if (((BooleanValue)e).toBoolean() == true)
					return b;
			} else { 
				canEvaluate = false;
			}
		}
		return new ProgramIfThenElse<T>(conditions_p, branches_p);
	}
	
	@Override
	public String toString() {
		String s = "";
		boolean first = true;
		Iterator<BooleanExpression> condition = conditions.iterator();
		Iterator<ProgramExpression<T>> branch =  branches.iterator();
		while (condition.hasNext() && branch.hasNext()) {
			s += (first ? "if " : " else " ) + condition.next() + " " + branch.next();
			first = false;
		}
		return s;
	}
}
