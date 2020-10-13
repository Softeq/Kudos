
export const mapArraysEquals = (array1: Array<Map<string, any>>, array2: Array<Map<string, any>>): boolean => {
    if (array1.length !== array2.length) {
        return false;
    }

    const sortedArray1 = array1.sort(mapComparer);
    const sortedArray2 = array2.sort(mapComparer);

    for (let i = 0; i < sortedArray1.length; i++) {
        if (!mapEquals(sortedArray1[i], sortedArray2[i]))
        {
            return false;
        }
    }

    return true;
}

const mapEquals = (map1: Map<string, any>, map2: Map<string, any>): boolean => {
    if (map1.size !== map2.size) {
        return false;
    }

    for (const key in map1.keys) {
        if (!map2.has(key) || map1.get(key) !== map2.get(key)) {
            return false;
        }
    }

    return true;
}

const mapComparer = (map1: Map<string, any>, map2: Map<string, any>) => {
    if (map1.get("id") > map2.get("id")) {
        return 1;
    }

    if (map1.get("id") < map2.get("id")) {
        return -1;
    }

    return 0;
}