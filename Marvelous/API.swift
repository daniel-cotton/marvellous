//  This file was automatically generated and should not be edited.

import Apollo

public enum SourcePlatformEnum: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case dropbox
  case gdrive
  case creativeCloud
  case directUpload
  case canvas
  case box
  case easel
  case sketch
  case pop
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DROPBOX": self = .dropbox
      case "GDRIVE": self = .gdrive
      case "CREATIVE_CLOUD": self = .creativeCloud
      case "DIRECT_UPLOAD": self = .directUpload
      case "CANVAS": self = .canvas
      case "BOX": self = .box
      case "EASEL": self = .easel
      case "SKETCH": self = .sketch
      case "POP": self = .pop
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .dropbox: return "DROPBOX"
      case .gdrive: return "GDRIVE"
      case .creativeCloud: return "CREATIVE_CLOUD"
      case .directUpload: return "DIRECT_UPLOAD"
      case .canvas: return "CANVAS"
      case .box: return "BOX"
      case .easel: return "EASEL"
      case .sketch: return "SKETCH"
      case .pop: return "POP"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: SourcePlatformEnum, rhs: SourcePlatformEnum) -> Bool {
    switch (lhs, rhs) {
      case (.dropbox, .dropbox): return true
      case (.gdrive, .gdrive): return true
      case (.creativeCloud, .creativeCloud): return true
      case (.directUpload, .directUpload): return true
      case (.canvas, .canvas): return true
      case (.box, .box): return true
      case (.easel, .easel): return true
      case (.sketch, .sketch): return true
      case (.pop, .pop): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class MainQueryQuery: GraphQLQuery {
  public static let operationString =
    "query MainQuery {\n  user {\n    __typename\n    username\n    projects {\n      __typename\n      pageInfo {\n        __typename\n        hasNextPage\n        endCursor\n      }\n      edges {\n        __typename\n        node {\n          __typename\n          createdAt\n          pk\n          name\n          prototypeUrl\n          screens(first: 1) {\n            __typename\n            edges {\n              __typename\n              node {\n                __typename\n                externalId\n                name\n                uploadUrl\n                sourcePlatform\n                sectionPk\n                content {\n                  __typename\n                  ...image\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}"

  public static var requestString: String { return operationString.appending(Image.fragmentString) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Queries"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("user", type: .object(User.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(user: User? = nil) {
      self.init(snapshot: ["__typename": "Queries", "user": user.flatMap { (value: User) -> Snapshot in value.snapshot }])
    }

    /// Get the authenticated user. Requires user:read scope.
    public var user: User? {
      get {
        return (snapshot["user"] as? Snapshot).flatMap { User(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "user")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes = ["UserNode"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .scalar(String.self)),
        GraphQLField("projects", type: .object(Project.selections)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(username: String? = nil, projects: Project? = nil) {
        self.init(snapshot: ["__typename": "UserNode", "username": username, "projects": projects.flatMap { (value: Project) -> Snapshot in value.snapshot }])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var username: String? {
        get {
          return snapshot["username"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      /// Projects a user owns or is collaborating on. Requires projects:read scope.
      public var projects: Project? {
        get {
          return (snapshot["projects"] as? Snapshot).flatMap { Project(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "projects")
        }
      }

      public struct Project: GraphQLSelectionSet {
        public static let possibleTypes = ["ProjectConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(pageInfo: PageInfo, edges: [Edge?]) {
          self.init(snapshot: ["__typename": "ProjectConnection", "pageInfo": pageInfo.snapshot, "edges": edges.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } }])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var pageInfo: PageInfo {
          get {
            return PageInfo(snapshot: snapshot["pageInfo"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "pageInfo")
          }
        }

        public var edges: [Edge?] {
          get {
            return (snapshot["edges"] as! [Snapshot?]).map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } }
          }
          set {
            snapshot.updateValue(newValue.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } }, forKey: "edges")
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes = ["PageInfo"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("endCursor", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(hasNextPage: Bool, endCursor: String? = nil) {
            self.init(snapshot: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "endCursor": endCursor])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return snapshot["hasNextPage"]! as! Bool
            }
            set {
              snapshot.updateValue(newValue, forKey: "hasNextPage")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return snapshot["endCursor"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "endCursor")
            }
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes = ["ProjectEdge"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(node: Node? = nil) {
            self.init(snapshot: ["__typename": "ProjectEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge
          public var node: Node? {
            get {
              return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
            }
            set {
              snapshot.updateValue(newValue?.snapshot, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes = ["ProjectNode"]

            public static let selections: [GraphQLSelection] = [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("pk", type: .nonNull(.scalar(Int.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("prototypeUrl", type: .nonNull(.scalar(String.self))),
              GraphQLField("screens", arguments: ["first": 1], type: .object(Screen.selections)),
            ]

            public var snapshot: Snapshot

            public init(snapshot: Snapshot) {
              self.snapshot = snapshot
            }

            public init(createdAt: String, pk: Int, name: String, prototypeUrl: String, screens: Screen? = nil) {
              self.init(snapshot: ["__typename": "ProjectNode", "createdAt": createdAt, "pk": pk, "name": name, "prototypeUrl": prototypeUrl, "screens": screens.flatMap { (value: Screen) -> Snapshot in value.snapshot }])
            }

            public var __typename: String {
              get {
                return snapshot["__typename"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Project creation time
            public var createdAt: String {
              get {
                return snapshot["createdAt"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "createdAt")
              }
            }

            public var pk: Int {
              get {
                return snapshot["pk"]! as! Int
              }
              set {
                snapshot.updateValue(newValue, forKey: "pk")
              }
            }

            public var name: String {
              get {
                return snapshot["name"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "name")
              }
            }

            /// Unique URL to view the prototype.
            public var prototypeUrl: String {
              get {
                return snapshot["prototypeUrl"]! as! String
              }
              set {
                snapshot.updateValue(newValue, forKey: "prototypeUrl")
              }
            }

            /// Screens associated with this project
            public var screens: Screen? {
              get {
                return (snapshot["screens"] as? Snapshot).flatMap { Screen(snapshot: $0) }
              }
              set {
                snapshot.updateValue(newValue?.snapshot, forKey: "screens")
              }
            }

            public struct Screen: GraphQLSelectionSet {
              public static let possibleTypes = ["ScreenConnection"]

              public static let selections: [GraphQLSelection] = [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("edges", type: .nonNull(.list(.object(Edge.selections)))),
              ]

              public var snapshot: Snapshot

              public init(snapshot: Snapshot) {
                self.snapshot = snapshot
              }

              public init(edges: [Edge?]) {
                self.init(snapshot: ["__typename": "ScreenConnection", "edges": edges.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } }])
              }

              public var __typename: String {
                get {
                  return snapshot["__typename"]! as! String
                }
                set {
                  snapshot.updateValue(newValue, forKey: "__typename")
                }
              }

              public var edges: [Edge?] {
                get {
                  return (snapshot["edges"] as! [Snapshot?]).map { (value: Snapshot?) -> Edge? in value.flatMap { (value: Snapshot) -> Edge in Edge(snapshot: value) } }
                }
                set {
                  snapshot.updateValue(newValue.map { (value: Edge?) -> Snapshot? in value.flatMap { (value: Edge) -> Snapshot in value.snapshot } }, forKey: "edges")
                }
              }

              public struct Edge: GraphQLSelectionSet {
                public static let possibleTypes = ["ScreenEdge"]

                public static let selections: [GraphQLSelection] = [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("node", type: .object(Node.selections)),
                ]

                public var snapshot: Snapshot

                public init(snapshot: Snapshot) {
                  self.snapshot = snapshot
                }

                public init(node: Node? = nil) {
                  self.init(snapshot: ["__typename": "ScreenEdge", "node": node.flatMap { (value: Node) -> Snapshot in value.snapshot }])
                }

                public var __typename: String {
                  get {
                    return snapshot["__typename"]! as! String
                  }
                  set {
                    snapshot.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The item at the end of the edge
                public var node: Node? {
                  get {
                    return (snapshot["node"] as? Snapshot).flatMap { Node(snapshot: $0) }
                  }
                  set {
                    snapshot.updateValue(newValue?.snapshot, forKey: "node")
                  }
                }

                public struct Node: GraphQLSelectionSet {
                  public static let possibleTypes = ["ScreenNode"]

                  public static let selections: [GraphQLSelection] = [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("externalId", type: .scalar(String.self)),
                    GraphQLField("name", type: .scalar(String.self)),
                    GraphQLField("uploadUrl", type: .nonNull(.scalar(String.self))),
                    GraphQLField("sourcePlatform", type: .scalar(SourcePlatformEnum.self)),
                    GraphQLField("sectionPk", type: .scalar(Int.self)),
                    GraphQLField("content", type: .object(Content.selections)),
                  ]

                  public var snapshot: Snapshot

                  public init(snapshot: Snapshot) {
                    self.snapshot = snapshot
                  }

                  public init(externalId: String? = nil, name: String? = nil, uploadUrl: String, sourcePlatform: SourcePlatformEnum? = nil, sectionPk: Int? = nil, content: Content? = nil) {
                    self.init(snapshot: ["__typename": "ScreenNode", "externalId": externalId, "name": name, "uploadUrl": uploadUrl, "sourcePlatform": sourcePlatform, "sectionPk": sectionPk, "content": content.flatMap { (value: Content) -> Snapshot in value.snapshot }])
                  }

                  public var __typename: String {
                    get {
                      return snapshot["__typename"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// User-supplied identifier. Can not change once set, and visible to other API clients.
                  public var externalId: String? {
                    get {
                      return snapshot["externalId"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "externalId")
                    }
                  }

                  /// The screen's name
                  public var name: String? {
                    get {
                      return snapshot["name"] as? String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "name")
                    }
                  }

                  /// A URL to which screen content can be uploaded. See our docs: https://marvelapp.com/developers/documentation/uploads/
                  public var uploadUrl: String {
                    get {
                      return snapshot["uploadUrl"]! as! String
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "uploadUrl")
                    }
                  }

                  /// The platform from which the content was uploaded to Marvel.
                  public var sourcePlatform: SourcePlatformEnum? {
                    get {
                      return snapshot["sourcePlatform"] as? SourcePlatformEnum
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "sourcePlatform")
                    }
                  }

                  /// The section pk that this screen belongs to. None if not grouped
                  public var sectionPk: Int? {
                    get {
                      return snapshot["sectionPk"] as? Int
                    }
                    set {
                      snapshot.updateValue(newValue, forKey: "sectionPk")
                    }
                  }

                  /// The content belonging to a screen. Resolves to null if content is yet to be uploaded.
                  public var content: Content? {
                    get {
                      return (snapshot["content"] as? Snapshot).flatMap { Content(snapshot: $0) }
                    }
                    set {
                      snapshot.updateValue(newValue?.snapshot, forKey: "content")
                    }
                  }

                  public struct Content: GraphQLSelectionSet {
                    public static let possibleTypes = ["ImageScreen"]

                    public static let selections: [GraphQLSelection] = [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("filename", type: .scalar(String.self)),
                      GraphQLField("url", type: .scalar(String.self)),
                      GraphQLField("height", type: .scalar(Int.self)),
                      GraphQLField("width", type: .scalar(Int.self)),
                    ]

                    public var snapshot: Snapshot

                    public init(snapshot: Snapshot) {
                      self.snapshot = snapshot
                    }

                    public init(filename: String? = nil, url: String? = nil, height: Int? = nil, width: Int? = nil) {
                      self.init(snapshot: ["__typename": "ImageScreen", "filename": filename, "url": url, "height": height, "width": width])
                    }

                    public var __typename: String {
                      get {
                        return snapshot["__typename"]! as! String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var filename: String? {
                      get {
                        return snapshot["filename"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "filename")
                      }
                    }

                    public var url: String? {
                      get {
                        return snapshot["url"] as? String
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "url")
                      }
                    }

                    public var height: Int? {
                      get {
                        return snapshot["height"] as? Int
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "height")
                      }
                    }

                    public var width: Int? {
                      get {
                        return snapshot["width"] as? Int
                      }
                      set {
                        snapshot.updateValue(newValue, forKey: "width")
                      }
                    }

                    public var fragments: Fragments {
                      get {
                        return Fragments(snapshot: snapshot)
                      }
                      set {
                        snapshot += newValue.snapshot
                      }
                    }

                    public struct Fragments {
                      public var snapshot: Snapshot

                      public var image: Image {
                        get {
                          return Image(snapshot: snapshot)
                        }
                        set {
                          snapshot += newValue.snapshot
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public struct Image: GraphQLFragment {
  public static let fragmentString =
    "fragment image on ImageScreen {\n  __typename\n  filename\n  url\n  height\n  width\n}"

  public static let possibleTypes = ["ImageScreen"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("filename", type: .scalar(String.self)),
    GraphQLField("url", type: .scalar(String.self)),
    GraphQLField("height", type: .scalar(Int.self)),
    GraphQLField("width", type: .scalar(Int.self)),
  ]

  public var snapshot: Snapshot

  public init(snapshot: Snapshot) {
    self.snapshot = snapshot
  }

  public init(filename: String? = nil, url: String? = nil, height: Int? = nil, width: Int? = nil) {
    self.init(snapshot: ["__typename": "ImageScreen", "filename": filename, "url": url, "height": height, "width": width])
  }

  public var __typename: String {
    get {
      return snapshot["__typename"]! as! String
    }
    set {
      snapshot.updateValue(newValue, forKey: "__typename")
    }
  }

  public var filename: String? {
    get {
      return snapshot["filename"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "filename")
    }
  }

  public var url: String? {
    get {
      return snapshot["url"] as? String
    }
    set {
      snapshot.updateValue(newValue, forKey: "url")
    }
  }

  public var height: Int? {
    get {
      return snapshot["height"] as? Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "height")
    }
  }

  public var width: Int? {
    get {
      return snapshot["width"] as? Int
    }
    set {
      snapshot.updateValue(newValue, forKey: "width")
    }
  }
}