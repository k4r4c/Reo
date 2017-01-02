package nl.cwi.reo.interpret;

/**
 * A Treo expression that unifies strings, boolean expressions, integer expressions, 
 * component expressions, and lists of expressions.
 */
public interface Evaluable<T> {
	
	/**
	 * Substitutes expressions for free variables in this expression.
	 * @param params			parameter assignment
	 * @return new expression with variables substituted.
	 * @throws Exception if any substituted expression is of the wrong type.
	 */
	public T evaluate(DefinitionList params) throws Exception;
}