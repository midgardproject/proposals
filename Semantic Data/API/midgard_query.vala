using GLib;
using Gda;

namespace Midgard
{

public interface IQuery
{
    public set_constraint(QueryConstraintSimple property);
    public set_offset(int offset);
    public set_limit(int limit);
    public add_order(QueryProperty property, string direction);
    public add_join(Gda.SqlSelectJoinType join_type, QueryProperty left, QueryProperty right);
}

struct qsj {
    QueryProperty *left_property;
    QueryProperty *right_property;
    Gda.SqlSelectJoinType join_type;
}

public class QuerySelect : IQuery
{
    public QueryStorage storage { get; set; }
    public QueryConstraintSimple constraint { get; set; }
    public int offset { get; set; }
    public int limit { get; set; }
    public Glib.Pair<QueryProperty, string>[] orders { get; set; }
    public qsj[] joins { get; set; }

    public QuerySelect(QueryStorage storage);

    public set_constraint(QueryConstraintSimple property);
    public set_offset(int offset);
    public set_limit(int limit);
    public add_order(QueryProperty property, string direction);
    public add_join(Gda.SqlSelectJoinType join_type, QueryProperty left, QueryProperty right);
}

public abstract class QueryExecutor : IQuery
{
    public set_constraint(QueryConstraintSimple property);
    public set_offset(int offset);
    public set_limit(int limit);
    public add_order(QueryProperty property, string direction);
    public add_join(string join_type, QueryProperty left, QueryProperty right);

    public execute();
    public get_results_count();
}

public class QuerySelectRaw : QueryExecutor
{
    public static fromQuerySelect(QuerySelect source_query)
    {
        SchemaMapper mapper = SchemaMapper.get_instance();

        var base_class = source_query.storage.dbclass;
        var mapping = mapper.getMapping(base_class);

        QueryStorage base_storage = null;
        QuerySelectRaw query = null;
        QueryConstraintSimple constraint = null;

        if (mapping._table) {
            base_storage = new QueryStorage(mapping._table);
            query = new QuerySelectRaw(base_storage);
        } else {
            base_storage = new QueryStorage("parameters");
            query = new QuerySelectRaw(base_storage);

            /*
            Need to implement this:
                SELECT
                    `t1`.`value` AS `guid`
                FROM
                    `parameters` AS `t1`
                WHERE
                    `t1`.`name` = 'hasClass' AND `t1`.`value` = class;
            */
            constraint = new QueryConstraint
        }
    }

    public QuerySelectRaw(QueryStorage storage);

    public toggle_readonly(bool readonly);
    public include_deleted(bool include_deleted);
    public list_objects();
    
}


}
