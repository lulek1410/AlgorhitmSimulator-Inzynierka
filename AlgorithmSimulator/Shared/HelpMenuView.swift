//
//  HelpManuView.swift
//  AlgorithmSimulator-macOS
//
//  Created by Janek on 11/10/2021.
//

import SwiftUI

/// Help view containing text and images giving basic information about the application and explaining how to use it.
struct HelpMenuView: View {
    var body: some View {
        ScrollView {
            VStack{
                LabeledDivider(label: "Description", font_size: 14, horizontal_padding: 10)
                Text("""
                Application was writen by Jan Szewczyński and was ment to be used as easy way to basicaly test some pathfinding algorithms. Inside the programe there are implementations of 3 algorithms:
                    
                    1. A* (A star)
                    2. Dijkstra
                    3. custom Dijkstra implementation (multithread)
                
                Also there is an editor which allows user to create their own testing grounds using provided object's shapes and modifiable parameters of those objects. In further parts of this help view i will try to make it easier to use the application for new users using images to make it easier to understad.
                
                """).padding(.horizontal, 15)
                
                LabeledDivider(label: "Adding objects", font_size: 14, horizontal_padding: 10)
                HStack {
                    VStack {
                        Image("Obstacles menu")
                        Text("Image 1. Obstacles menu")
                    }
                    VStack {
                        Text("""
                        To add a new object weather it will be a start/end point or obsctacle for algorithm, we need to make use of the menu visible on the right side of application window (Image 1).
                        
                        Firstly we need to decide weather we want to add start or end point objects. Adding those objects require provideing only position parameters. Other parameters that are not relevant to placing start/end object in the scene will be disabled to make it easier to understand what is trully needed for object to be created.
                        
                         In case of adding an obstacle object we need to decide what kind of shape we want to include to our scene. Selecting one of available shapes also makes irelevant parameters disabled for easier application use. Different shapes have different parameters relevant to their creation so picking right one at the start saves us providing unnecessary parameters.
                        
                        For "Box" and "Pyramid" shape position properties define a position of lower left vertex of given shape while in "Sphere" shape it defines position of sphere's center. In case of Size properties "Sphere" shape requires only radius to be created. Radius property is relevant only to spherically shaped obstacles.
                        
                        Not provideing one or more of needed parameters (leaving it at 0) make it equal to 0.1 to prevent placement of invisible or too small objects that cant be modified.
                        
                        Pyramid peak position is a parameter relevant only to "Pyramid" shaped obstacles. Pyramid shaped obstacles are created to represent one of quarters fo a full pyramid so in order to create full pyramid you will need 4 pyramid shaped obstacles, each with different peak position.
                        
                        In order to add obstacle for which we provided data we simply need to press button with "Add object" on it.
                        
                        """)
                        Spacer()
                        LabeledDivider(label: "Interacting with objects", font_size: 14, horizontal_padding: 10)
                        Text("""
                        
                        In order to interract with already added objects we need to sellect the object by clicking on it in editor view (Image 2). If object got selected it should start flashing white which makes it easier to identify weather and ehich object was selected.
                        
                        If an object is sellected, view obstacles menu (Image 1) should get all parameters of selected obstacle and display them in the corresponding fields. Changing values in the objects view updates objects parameters in real time so you can move and resize already created objects in order to modify the scene to your likeing.
                        
                        Sellected obstacles can also be deleted by pressing "Delete object" button in obstacles menu (Image 1)
                        
                        """)
                        Image("Editor menu")
                        HStack {
                            Spacer()
                            Text("Image 2. Editor View")
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 10)
                }
                VStack {
                    LabeledDivider(label: "Editor View", font_size: 14, horizontal_padding: 10)
                    Text("""
                                
                        The first thing you will see running the application will be a big blue rectangle. It's called floor object. Floor object cant be moved or deleted. Only modificatons available are resizeing. This object represents the space on which pathfinding takes place. The test environment is sized based on floor object. Height of environment depend on heights point in the scene or if chosen, user defined height.
                                    
                        Main point of editor view is to allow user to visualize the test environment in which pathfinding takes place. Also it allows selecting already present obstacles in order to modify them.
                                
                        Another thing that is present in the editor view are two 3D text objects. One of them is at scene point correspondind to position x=0 and z=0 in the environment and the other one is at the end corresponding to x = environment_width, z = environment_lenght (in our case its (30, 30)). The two points inform user on environments size and make it easier to place new obstacles.
                                
                                                            
                        Editor view also provides options to modify camera position. The interactions that need to be performed in order to move the camera are very similar to handling a smartphone. Moves available are:
                        -> click+drag = move camera around center of it's field of view
                        -> drag two fingers outwards = zoom in
                        -> drag two fingers inwards = zoom out
                        -> drag two fingers one up, second down = rotate camera right/left
                        -> drag two fingers in one direction = move camera along x or y axis
                        
                        """)
                    
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                LabeledDivider(label: "Algorithms manu", font_size: 14, horizontal_padding: 10)
                HStack {
                    VStack {
                        Image("Algorithm menu")
                        Text("Image 3. Algorithm menu")
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    VStack {
                        Text("""
                    This menu is used to pick pathfinding algorithm to use in order to find path betwean start and end point. The view is visible on image 3. As you can see Astar algorithm has bonus option which distinguishes it from others. It's the type of heuristics used by the algorithm. There are two options which are: Diagonal and Euclidean.
                    
                    This view also provides some options for either displaying the path or modifying the grid on which the algorithm works. The disply options allow dynamic path drawing ("Dynamic path search display") during algorithm work which allows us to see how the algoritm finds the path betwean points and drawing all nodes visited by algorithm ("Display all visited nodes"). You can only select one of them. The options responsible for modifying the grid are setting fixed height for the environment (normally environment height is based on heigest point present in scene), altitude change cost modifier which makes movement betwean points on different y axis position more costly (multiplying the base cost by given value) and higher altitude movement modifier which multiplyes base cost of distance betwean nodes if they have y axis position higher than 0.
                    
                    Also we are provided some statistics wchich we can use in order to test algorithm and their performance. Available statistics are:
                    - time algorithm needs to find path
                    - calculated distance betwean start and end point
                    - number of nodes that have been taken into consideration when searching path (all visited and discovered nodes)
                    - distance betwean start and end point in traversed nodes
                    
                    In order to start searching for shortest path we need to select one of available algorithms, set wanted options and simply click "Find path" button. Also there need to be start and end point set in order for algorithm to have an idea from where to where to search. There can be multile path displayed in editor view (one for each algorithm). In order to delete all paths from editor view we need to deselect any algorithm and press "Delete path" button. We also can delete only one single path which belongs to specific algorithm by selecting algorithm whose path we want to delete and press "Delete path".
                    
                    If pathfinding takes a lot of time from whatever reason we are provided with "Break Algorithm" button which stops currently working algorithm to prevent blocking the application for a long time.
                    """)
                        LabeledDivider(label: "Files menu", font_size: 14, horizontal_padding: 10)
                        Text("""
                    Files menu which we can seee on image 4 is used to manage files with saved maps on them. This view can be displayed by clicking "Files" button in objects menu (Image 1) and replaces objects menu. In order to go back to displaying objects menu we need to click "Back" button in top right corner of files menu.
                    
                    In the central part of files menu there is a list with already existing file names with saved maps on them. In order to save current environment (map) we either need to select already existing file and press "Save" which will result in overwriting the file or give a new filename in "Save as:" textfield and then pressing "Save" to create new file which should now be visible in files list.
                    
                    Loading previously saved map is done by selecting file from list and simply pressing "Load" button.
                    
                    Deleting save files is done by pressing "Delete selected" button while either one of files in file list in selected.
                    """)
                    }
                }
                Image("Files menu")
                Text("Image 4. Files menu")
                Spacer()
            }.frame(height: 2950)
        }
    }
}
