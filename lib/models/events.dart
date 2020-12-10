class Events {
  //for the layout => position : with a counter
  int position;
  List<String> members;
  String title;
  String avatar;
  String description;
  List<String> images;

  Events({
    this.position,
    this.members,
    this.title,
    this.avatar,
    this.description,
    this.images,
  });

  Map toMap(Events events) {
    var data = Map<String, dynamic>();
    data["position"] = events.position;
    data['members'] = events.members;
    data['title'] = events.title;
    data['avatar'] = events.avatar;
    data['description'] = events.description;
    data['images'] = events.images;
    return data;
  }

//parse the map and create a user object
  Events.fromMap(Map<String, dynamic> mapData) {
    this.position = mapData['position'];
    this.members = mapData['members'];
    this.title = mapData['title'];
    this.avatar = mapData['avatar'];
    this.description = mapData['description'];
    this.images = mapData['images'];
  }
}

List<Events> events = [
  Events(
      position: 1,
      members: ["userid1", "userid2", "userid3"],
      title: "HELOOOLLL",
      avatar:
          "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ]),
  Events(
      position: 2,
      members: ["userid1", "userid2", "userid3"],
      title: "Testnezfg",
      avatar:
          "https://cdn.jpegmini.com/user/images/slider_puffin_before_mobile.jpg",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ]),
  Events(
      position: 3,
      members: ["userid1", "userid2", "userid3"],
      title: "HELOOOLLL",
      avatar:
          "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ]),
  Events(
      position: 4,
      members: ["userid1", "userid2", "userid3"],
      title: "Testnezfg",
      avatar:
          "https://cdn.jpegmini.com/user/images/slider_puffin_before_mobile.jpg",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ]),
  Events(
      position: 5,
      members: ["userid1", "userid2", "userid3"],
      title: "HELOOOLLL",
      avatar:
          "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ]),
  Events(
      position: 6,
      members: ["userid1", "userid2", "userid3"],
      title: "Testnezfg",
      avatar:
          "https://cdn.jpegmini.com/user/images/slider_puffin_before_mobile.jpg",
      description: "lroimzel lazehr lazhke rlfùpia^pfi ^zaepif",
      images: [
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
        "https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHw%3D&w=1000&q=80",
      ])
];
