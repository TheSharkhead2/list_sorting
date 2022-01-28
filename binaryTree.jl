# binary tree type
mutable struct Tree 
    value::Float64 #value at this node
    lChild::Union{Tree, Nothing} #left child
    rChild::Union{Tree, Nothing} #right child
    lDepth::Int32 #depth of left child (this doesn't update all the time and will probably be wrong most of the time)
    rDepth::Int32 #depth of right child (this doesn't update all the time and will probably be wrong most of the time)
end

"""
Insert element x into a tree

Parameters
----------

x : Float64
    Float to be inserted into tree

tree : Tree
    Tree to insert item into

"""
function insert!(x, tree)

    itemInserted = false #bool for while loop

    SubTreeDirectionList = [] # list of directions down to inserted value

    tempSubTree = tree

    while itemInserted == false #loop until can insert item 

         if x < tempSubTree.value #if x is less than value of tempSubTree
            if tempSubTree.lChild == nothing #if left child is nothing

                tempSubTree.lChild = Tree(x, nothing, nothing, 0, 0) #insert x into left child

                pushfirst!(SubTreeDirectionList, "left") #push left into list

                itemInserted = true #item inserted

            else #if left child is not nothing

                #follow left child
                tempSubTree = tempSubTree.lChild

               pushfirst!(SubTreeDirectionList, "left") #record history of traversal

            end

        else #if x is greater than value of tempSubTree
            if tempSubTree.rChild == nothing #if right child is nothing

                tempSubTree.rChild = Tree(x, nothing, nothing, 0, 0) #insert x into right child

                pushfirst!(SubTreeDirectionList, "right") #push right into list

                itemInserted = true #item inserted

            else #if right child is not nothing

                #follow right child
                tempSubTree = tempSubTree.rChild

                pushfirst!(SubTreeDirectionList, "right") #record history of traversal

            end
        end
    end

    #now that item is inserted into tree, generate list of subtrees 

    SubTreeList = [tree] #list of subtrees

    tempSubTree = tree

    for direction in reverse(SubTreeDirectionList) #loop through the reverse of the directions up from inserted item 
        if direction == "left" #if direction is left
            pushfirst!(SubTreeList, tempSubTree.lChild) #push left child into list

            tempSubTree = tempSubTree.lChild #follow left child

        else #if direction is right
            pushfirst!(SubTreeList, tempSubTree.rChild) #push right child into list

            tempSubTree = tempSubTree.rChild #follow right child

        end
    end

    #now go through list of subtrees, update depths, and find first unbalanced subtree
    for (index, subTree) in enumerate(SubTreeList)
        if subTree.lChild == nothing #if left child is nothing, left depth is 0 
            subTree.lDepth = 0
        else #if left child is not nothing, left depth is 1 + left child's depth

            subTree.lDepth = 1 + maximum([subTree.lChild.lDepth, subTree.lChild.rDepth])
        end

        #same as above, but for right child 
        if subTree.rChild == nothing
            subTree.rDepth = 0
        else
            subTree.rDepth = 1 + maximum([subTree.rChild.lDepth, subTree.rChild.rDepth])
        end

        #if left depth - right depth is greater than 1, node is unbalanced and we need to perform a series of rotations
        if subTree.lDepth - subTree.rDepth > 1 && index > 3 #need index greater than three for cheap fix to indexing at 0 (which shouldn't be possible?)

            #need to find what type of rotations are necessary 
            if SubTreeDirectionList[index-1] == "left" && SubTreeDirectionList[index-2] == "left" #left left case. Looking at direction from this subtree and direction from that subtree (towards inserted node)
                #perform right rotation on subtree 
                rightRotate!(subTree)

            #left right case
            elseif SubTreeDirectionList[index - 1] == "left" && SubTreeDirectionList[index-2] == "right" #left right case. Looking at direction from this subtree and direction from that subtree (towards inserted node)
                #perform left rotation on left child
                leftRotate!(subTree.lChild)

                #perform right rotation on subtree
                rightRotate!(subTree)

            #right left case
            elseif SubTreeDirectionList[index - 1] == "right" && SubTreeDirectionList[index-2] == "left" #right left case. Looking at direction from this subtree and direction from that subtree (towards inserted node)
                #perform right rotation on right child
                rightRotate!(subTree.rChild)

                #perform left rotation on subtree
                leftRotate!(subTree)

            #right right case
            elseif SubTreeDirectionList[index - 1] == "right" && SubTreeDirectionList[index-2] == "right" #right right case. Looking at direction from this subtree and direction from that subtree (towards inserted node)
                #perform left rotation on subtree
                leftRotate!(subTree)

            end
        end
    end

end

"""
Performs a right rotation on a tree

Parameters
----------

tree : Tree                             
    Tree to rotate

"""
function rightRotate!(tree)

    tempLeft = tree.lChild #save left child

    tempRight = tree.rChild #save right child

    tempTreeValue = tree.value #save value

    tree.value = tempLeft.value #set value of tree to value of left child 

    tree.lChild = tempLeft.lChild #set left child of tree to left child of left child 

    if tempLeft.rChild == nothing #if T2 (right child of left child) is nothing, left depth for final right child is 0
        leftDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        leftDepth = 1 + maximum([tempLeft.rChild.lDepth, tempLeft.rChild.rDepth])
    end

    if tempRight == nothing #if the right child is nothing, the right depth of the final right child is 0
        rightDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        rightDepth = 1 + maximum([tempRight.lDepth, tempRight.rDepth])
    end

    tree.rChild = Tree(tempTreeValue, tempLeft.rChild, tempRight, leftDepth, rightDepth)

    tree.rDepth = 1 + maximum([tree.rChild.lDepth, tree.rChild.rDepth]) #update right depth of tree

    if tree.lChild == nothing #if left child is nothing, left depth of tree is 0
        tree.lDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        tree.lDepth = 1 + maximum([tree.lChild.lDepth, tree.lChild.rDepth])
    end

end

"""
Performs a left rotation on a tree

Parameters
----------

tree : Tree                             
    Tree to rotate

"""
function leftRotate!(tree)
    
    tempRight = tree.rChild #save right child

    tempLeft = tree.lChild #save left child

    tempTreeValue = tree.value #save value

    tree.value = tempRight.value #set value of tree to value of right child

    tree.rChild = tempRight.rChild #set right child of tree to right child of right child

    if tempRight.lChild == nothing #if T2 (right child of right child) is nothing, then the right depth of the final left child is 0
        rightDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        rightDepth = 1 + maximum([tempRight.lChild.lDepth, tempRight.lChild.rDepth])
    end

    if tempLeft == nothing #if the left child is nothing, the left depth of the final left child is 0
        leftDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        leftDepth = 1 + maximum([tempLeft.lDepth, tempLeft.rDepth])
    end

    tree.lChild = Tree(tempTreeValue, tempLeft, tempRight.lChild, leftDepth, rightDepth)

    tree.lDepth = 1 + maximum([tree.lChild.lDepth, tree.lChild.rDepth]) #update left depth of tree

    if tree.rChild == nothing #if right child is nothing, right depth of tree is 0
        tree.rDepth = 0

    else #otherwise the depth is the maximum of its depths plus 1 
        tree.rDepth = 1 + maximum([tree.rChild.lDepth, tree.rChild.rDepth])
    end

end

""" 
Removes the minimum value from a tree and returns it 

Parameters
----------

tree : Tree
    Tree to remove minimum value from

Returns
-------

min : Float64
    Minimum value in tree

"""
function delete_min(tree)

    if tree.lChild == nothing && tree.rChild == nothing #when tree is only one remaining value, return that value 
        min = tree.value
        tree = nothing
        return min
    end

    subTreeHistory = [tree] #list of subtrees that have been visited

    tempSubTree = tree #temporary subtree to be used in while loop

    while tempSubTree.lChild != nothing #while the left child of the current subtree is not nothing
        pushfirst!(subTreeHistory, tempSubTree.lChild) #add the left child to the list of visited subtrees
        tempSubTree = tempSubTree.lChild #set the current subtree to the left child
    end

    min = tempSubTree.value #set min to the value of the current subtree 

    if length(subTreeHistory) == 1 #if the minimum value was simply the top value, then set tree to right child
        tree.value = tree.rChild.value #set value of tree to value of right child 
        tree.lChild = tree.rChild.lChild #set left child of tree to left child of right child
        tree.rChild = tree.rChild.rChild #set right child of tree to right child of right child

        subTreeHistory = [tree] #set the list of visited subtrees to the right child
    
    else #otherwise, perform below

        if tempSubTree.rChild == nothing #if doesn't have right child
            subTreeHistory[2].lChild = nothing #set left child of parent to nothing 
            
        else #if it does have a right child, then set the left child of the parent to the right child of the current subtree
            subTreeHistory[2].lChild = tempSubTree.rChild
            
        end 

        deleteat!(subTreeHistory, 1) #remove first item from list (which now doesn't need to exist as that has been overridden)

    end

    for subTree in subTreeHistory #loop through every subtree to update depths 
        if subTree.lChild == nothing #left child is nothing means left depth is nothing 
            subTree.lDepth = 0

        else #otherwise the depth is the maximum of its depths plus 1 
            subTree.lDepth = 1 + maximum([subTree.lChild.lDepth, subTree.lChild.rDepth])
        end

        if subTree.rChild == nothing #right child is nothing means right depth is nothing 
            subTree.rDepth = 0

        else #otherwise the depth is the maximum of its depths plus 1 
            subTree.rDepth = 1 + maximum([subTree.rChild.lDepth, subTree.rChild.rDepth])
        end
    end

    min

end

"""
Generates a balanced binary tree (using AVL trees) from a list

Parameters
----------

list : List
    List to generate tree from

Returns
-------

tree : Tree
    Balanced binary tree

"""
function generate_tree(list)

    binaryTree = Tree(list[1], nothing, nothing, 0, 0) #create blank tree with just first item

    deleteat!(list, 1) #remove first item from list

    for item in list #loop through list 
        insert!(item, binaryTree) #insert item into tree
    end

    binaryTree

end

"""
Performs a sorting algorithm which I sort of just made up (but used a
webpage on AVL trees to help me). This is an entirely custom algorithm
as I didn't look at any code snippets to create it, I just used the
description of the algorithm.

Parameters
----------

list : List
    List to sort

Returns
-------

sortedList : List
    Sorted list

"""
function theo_sort(list)

    binaryTree = generate_tree(list) #generate tree from list

    sortedList = [] #create empty list to store sorted list
    
    while binaryTree.lChild != nothing || binaryTree.rChild != nothing #when both children aren't nothing, then keep looping 
        min = delete_min(binaryTree) #delete minimum value from tree and store it in min
        push!(sortedList, min) #add min to sorted list
    end

    push!(sortedList, binaryTree.value) #add the final value to the sorted list (this won't have been deleted from the tree)

    sortedList

end

#if the first argument is test, then testing random list vs my algorithm
if ARGS[1] == "test"
    testList = rand(1:1000, parse(Int, ARGS[2])) #generate random list of size ARGS[2]

    startTimeJulia = time() #start timer for julia sort
    sortedList = sort(testList) #sort list using julia sort
    endTimeJulia = time() #end timer for julia sort

    juliaTime = endTimeJulia - startTimeJulia #calculate time taken for julia sort

    startTimeTheo = time() #start timer for theo sort
    sortedListTheo = theo_sort(testList) #sort list using theo sort
    endTimeTheo = time() #end timer for theo sort

    
    theoTime = endTimeTheo - startTimeTheo #calculate time taken for theo sort

    if sortedList == sortedListTheo #if the two lists are the same, then theo sort is correct
        println("Theo sort is correct")
    else #otherwise, theo sort is incorrect
        println("Theo sort is incorrect")
    end

    println("The Julia sorting algorithm took $juliaTime seconds and my algorithm took $theoTime seconds to sort ", ARGS[2], " items.") #print time taken for julia sort vs theo sort

elseif ARGS[1] == "insert" #test inserting speed 
    testList = rand(1:1000, parse(Int, ARGS[2])) #generate random list of size ARGS[2]

    testBinaryTree = generate_tree(testList) #generate tree from list

    insertNumber = rand(1:1000) #generate random number to insert

    startTime = time() #record start time 
    insert!(insertNumber, testBinaryTree) #insert number into tree 
    timeTaken = time() - startTime #get time taken 

    println("It took $timeTaken seconds to insert 1 item into a binary tree of ", ARGS[2], " items.") #print time taken to insert item

end
