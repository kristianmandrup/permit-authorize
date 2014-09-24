// Generated by LiveScript 1.2.0
(function(){
  var requires, Matcher, matcher;
  requires = require('../../../../requires');
  requires.test('test_setup');
  Matcher = requires.lib('access_request').matcher.SubjectMatcher;
  matcher = function(req){
    return new Matcher(req);
  };
  describe('SubjectMatcher', function(){
    var subjectMatcher, book, bookTitle, requests;
    requests = {};
    before(function(){
      book = new Book({
        title: 'the return of the jedi'
      });
      return requests.book = {
        subject: book
      };
    });
    describe('create', function(){
      beforeEach(function(){
        return subjectMatcher = matcher(requests.book);
      });
      return specify('must have admin access request', function(){
        return subjectMatcher.accessRequest.should.eql(requests.book);
      });
    });
    return describe('match', function(){
      beforeEach(function(){
        return subjectMatcher = matcher(requests.book);
      });
      specify('should match book: the return of the jedi', function(){
        return subjectMatcher.match({
          title: book.title
        }).should.be['true'];
      });
      specify('should NOT match book: the return to oz', function(){
        return subjectMatcher.match({
          title: 'the return to oz'
        }).should.be['false'];
      });
      return specify('should match on no argument', function(){
        return subjectMatcher.match().should.be['true'];
      });
    });
  });
}).call(this);
