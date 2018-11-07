package boost.util.ds;

import boost.util.DestroyUtil;
import boost.util.ds.Pool;
import h2d.col.Bounds;

/**
 * Simple QuadTree implementation to assist with broad-phase 2D collisions.
 * 
 * TODO: Doc this boi up!
 */
class QuadTree extends Bounds implements IPooled {

    public static var max_depth:Int = 5;
    public static var max_objects:Int = 15;
    public static var pool(get, never):IPool<QuadTree>;
    static var _pool = new Pool<QuadTree>(QuadTree);

    public var children:Array<QuadTree>;
    public var contents:Array<QuadTreeData>;
    public var count(get, null):Int;
    public var leaf(get, null):Bool;
    public var depth:Int;
    var in_pool:Bool;

    function new(?bounds:Bounds, depth:Int = 0) {
        super();
        if (bounds != null) load(bounds);
        this.depth = depth;
        children = [];
        contents = [];
    }

    public inline function put() {
		if (!in_pool) {
			in_pool = true;
			_pool.putUnsafe(this);
		}
	}

	public static inline function get(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):QuadTree {
		var qt = _pool.get();
        qt.set(x, y, width, height);
		qt.in_pool = false;
		return qt;
	}

    public function destroy() {
        for (child in children) child.put();
        children = [];
        DestroyUtil.destroyArray(contents);
    }

    public function insert(data:QuadTreeData) {
        // If the new data does not intersect this node, stop.
        if (!data.bounds.intersects(this)) return;
        // If the node is a leaf and contains more than the maximum allowed, split it.
        if (leaf && contents.length + 1 > max_objects) split();
        // If the node is still a leaf, push the data to it.
        // Else try to insert the data into the node's children
        if (leaf) contents.push(data);
        else for(child in children) child.insert(data);
    }

    public function remove(data:QuadTreeData) {
        if (leaf) {
            var items = contents.filter((d) -> d.id == data.id);
            for (item in items) contents.remove(item);
        } else for (child in children) child.remove(data);
        shake();
    }

    public function update(data:QuadTreeData) {
        remove(data);
        insert(data);
    }

    function shake() {
        if (!leaf) {
            var len = count;
            if (len == 0) clear_children();
            else if (len < max_objects) {
                var nodes = new List<QuadTree>();
                nodes.push(this);
                while (nodes.length > 0) {
                    var node = nodes.last();
                    if (node.leaf) for (data in node.contents) contents.push(data);
                    else for (child in node.children) nodes.push(child);
                    nodes.pop();
                }
                clear_children();
            }
        }
    }

    function split() {
        if (depth + 1 >= max_depth) return;

        var w = width * 0.5;
        var h = height * 0.5;
        var c = getCenter();

        for (i in 0...3) {
            switch (i) {
                case 0:
                children.push(get(xMin, yMin, w, h));
                case 1:
                children.push(get(c.x, yMin, w, h));
                case 2:
                children.push(get(c.x, c.y, w, h));
                case 3:
                children.push(get(xMin, c.y, w, h));
            }
            children[i].depth = depth + 1;
        }
        for (i in 0...contents.length) {
            children[i].insert(contents[i]);
        }
        contents = [];
    }

    function reset() {
        if (leaf) for (data in contents) data.flag = false;
        else for (child in children) child.reset();
    }

    function query(bounds:Bounds):Array<QuadTreeData> {
        var result:Array<QuadTreeData> = [];
        if (intersects(bounds)) return result;
        if (leaf) {
            for (data in contents) if (data.bounds.intersects(bounds)) result.push(data);
        } else {
            for (child in children) {
                var recurse = child.query(bounds);
                if (recurse.length > 0) {
                    result = result.concat(recurse);
                }
            }
        }

        return result;
    }

    function clear_children() {
        for (child in children) child.put();
        children = [];
    }

    function get_count() {
        reset();
        // Initialize the count with this node's content's length
        var count = contents.length;
        for (data in contents) {
            data.flag = true;
        }

        // Create a list of nodes to process and push the current tree to it.
        var nodes = new List<QuadTree>();
        nodes.push(this);

        // Process the nodes.
        // While there still nodes to process, grab the last node in the list.
        // If the node is a leaf, add all its contents to the count.
        // Else push this node's children to the end of the node list.
        // Finally, remove the node from the list.
        while (nodes.length > 0) {
            var node = nodes.last();
            if (node.leaf) {
                for (data in node.contents) {
                    if (!data.flag) {
                        count += 1;
                        data.flag = true;
                    }
                }
            } else for (child in children) nodes.push(child);
            nodes.pop();
        }
        reset();
        return count;
    }

    function get_leaf() return children.length == 0;

    static function get_pool():IPool<QuadTree> return _pool;
}

class QuadTreeData implements IDestroyable {
    /**
     * The ID of the Entity Data.
     */
    public var id:Int;
    /**
     * Bounds of the Entity Data.
     */
    public var bounds:Bounds;
    /**
     * Helper flag to check if this Data has been counted during queries.
     */
    public var flag:Bool;

    public function new(id:Int, bounds:Bounds) {
        this.id = id;
        this.bounds = bounds;
        flag = false;
    }

    public function destroy() {
        bounds = null;
    }
}